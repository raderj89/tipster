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
  validates :email, presence: true, length: { maximum: 100 },
            format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 6 }, unless: Proc.new { |a| a.password.blank? }

  # Paperclip
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" },
                    :default_url => "user_placeholder.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  delegate :card_type, :last_four, to: :payment_method

  # Methods
  def full_name
    "#{first_name} #{last_name}" 
  end

  def avatar_thumb
    avatar.url(:thumb)
  end

  def save_with_payment(card_info)
    if valid?
      binding.pry
      create_customer_on_stripe(card_info)
    end
  end

  def charge(transaction_amount)
    Stripe::Charge.create(amount: transaction_amount * 100,
                          customer: stripe_id,
                          currency: 'usd')
  end

  def update_or_create_card(card_info)
    if self.stripe_id
      update_customer_on_stripe(card_info)
      update_payment_method(card_info)
    else
      save_with_payment(card_info)
    end
  end

  private

    def generate_authentication_token
      self.authentication_token = SecureRandom.urlsafe_base64
    end

    def create_customer_on_stripe(card_info)
      stripe_customer_params = params_for_stripe_customer(card_info)
      binding.pry
      customer = Stripe::Customer.create(stripe_customer_params)
      binding.pry
      add_stripe_token(customer)
      create_payment_method(card_info)
    rescue Stripe::CardError => e
      logger.error "Stripe error while creating customer: #{e.message}"
      errors.add(:base, "There was a problem with your credit card.")
      false
    end

    def add_stripe_token(customer)
      self.stripe_id = customer.id
      save!
    end

    def params_for_stripe_customer(card_info)
      { description: full_name,
        card: card_params(card_info),
        email: email }
    end

    def card_params(card_info)
      { number: card_info[:card_number],
        exp_month: card_info[:expiration_month],
        exp_year: card_info[:expiration_year],
        cvc: card_info[:cvv] }
    end

    def create_payment_method(card_info)
      card_type = CardChecker.new(card_info[:card_number]).type
      payment = build_payment_method(card_type: card_type, last_four: card_info[:card_number][-4..-1])
      payment.save!
    end

    def update_customer_on_stripe(card_info)
      customer = Stripe::Customer.retrieve(self.stripe_id)
      customer.card = card_params(card_info)
      customer.save!
    end

    def update_payment_method(card_info)
      card_type = CardChecker.new(card_info[:card_number]).type
      payment_method.update(last_four: card_info[:card_number][-4..-1], card_type: card_type)
    end
end
