class User < ActiveRecord::Base

  # Callbacks
  before_save { self.email = email.downcase }
  before_save :generate_authentication_token

  # Relations
  has_many :property_relations, class_name: 'PropertyUser', foreign_key: 'user_id', dependent: :delete_all
  has_many :properties, through: :property_relations
  has_many :transactions
  has_many :tips, through: :transactions
  has_one :payment_method, dependent: :destroy

  accepts_nested_attributes_for :property_relations, allow_destroy: true

  # BCrypt
  has_secure_password

  # Email regex
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # Validations
  validates :first_name, presence: true, length: { maximum: 100 }
  validates :last_name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, length: { maximum: 100 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, unless: Proc.new { |a| a.password.blank? }

  # Paperclip
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "user_placeholder.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  # Methods

  def full_name
    "#{first_name} #{last_name}" 
  end

  def save_with_payment(card_info)
    if valid?
      customer = Stripe::Customer.create(description: full_name,
                                         email: email,
                                         card: { number: card_info[:card_number],
                                                 exp_month: card_info[:expiration_month],
                                                 exp_year: card_info[:expiration_year],
                                                 cvc: card_info[:cvv] })
      self.stripe_id = customer.id
      create_payment_method(card_info)
      save!
    end

    rescue Stripe::CardError => e
      logger.error "Stripe error while creating customer: #{e.message}"
      errors.add :base, "There was a problem with your credit card."
      false
  end

  def charge(transaction_amount)
    charge = Stripe::Charge.create(amount: transaction_amount * 100,
                                   customer: stripe_id,
                                   currency: 'usd')
  end

  def update_or_create_card(card_info)
    if self.stripe_id
      customer = Stripe::Customer.retrieve(self.stripe_id)

      customer.card = { number: card_info[:card_number],
                        exp_month: card_info[:expiration_month],
                        exp_year: card_info[:expiration_year],
                        cvc: card_info[:cvv] }
      customer.save
    else
      save_with_payment(card_info)
    end
    update_or_create_payment_method(card_info)
  end

  def avatar_thumb
    avatar.url(:thumb)
  end

  private

    def generate_authentication_token
      self.authentication_token = SecureRandom.urlsafe_base64
    end

    def create_payment_method(card_info)
      card_type = CardChecker.new(card_info[:card_number]).type
      payment = self.build_payment_method(card_type: card_type, last_four: card_info[:card_number][-4..-1])
      payment.save!

    rescue ActiveRecord::RecordNotUnique
      return false
    end

    def update_or_create_payment_method(card_info)
      card_type = CardChecker.new(card_info[:card_number]).type
      if self.payment_method
        self.payment_method.update(last_four: card_info[:card_number][-4..-1], card_type: card_type)
      else
        method = self.build_payment_method(last_four: card_info[:card_number][-4..-1], card_type: card_type)
        method.save!
      end
    end
end
