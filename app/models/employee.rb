class Employee < ActiveRecord::Base

  # Relations
  has_many :positions, inverse_of: :employee, class_name: 'PropertyEmployee', foreign_key: 'employee_id', dependent: :delete_all
  has_many :properties, through: :positions
  has_one :address, class_name: 'EmployeeAddress', foreign_key: 'employee_id'
  belongs_to :invitation
  has_many :sent_invitations, as: :sender, class_name: 'Invitation', foreign_key: 'sender_id'
  has_many :tips
  has_one :deposit_method

  # Nested Attributes
  accepts_nested_attributes_for :positions

  # Email regex
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # Validations
  validates :first_name, presence: true, length: { maximum: 100 }
  validates :last_name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, length: { maximum: 100 }, format: { with: VALID_EMAIL_REGEX }
  validates :password, length: { minimum: 6 }, unless: Proc.new { |a| a.password.blank? }

  # Paperclip
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  # BCrypt
  has_secure_password

  # Methods
  def full_name
    "#{first_name} #{last_name}"
  end

  def employees_managed
    if is_admin
      positions.map do |position|
        PropertyEmployee.where(property_id: position.property_id)
      end.flatten
    end
  end

  def manages?(property_employee)
    employees_managed.include?(property_employee)
  end

  def suggested_tip
    PropertyEmployee.find_by(employee_id: self.id).suggested_tip
  end

  def avatar_thumb
    avatar.url(:thumb)
  end

  # Invitation confirmation
  def invitation_token
    invitation.token if invitation
  end

  def invitation_token=(token)
    self.invitation = Invitation.find_by(token: token)
  end

  def invitation_is_admin
    invitation.is_admin if invitation
  end

  def invitation_position
    invitation.position if invitation
  end

  def setup_bank_deposit(bank_info)
    recipient = Stripe::Recipient.create(name: full_name,
                             type: 'individual',
                             email: email,
                             bank_account: bank_info.merge(country: 'US' ))
    stripe_id = recipient.id
    save!
    create_deposit_method(bank_info)
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating recipient: #{e.message}"
    errors.add(:base, "There was a problem with your bank information.")
    false
  end

  def update_bank_deposit(bank_info)
    recipient = Stripe::Recipient.retrieve(self.stripe_id)
    recipient.bank_account = bank_info.merge(country: 'US')
    recipient.save
    update_deposit_method(bank_info)
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while updating recipient: #{e.message}"
    errors.add(:base, "There was a problem updating your bank information.")
    false
  end

  def send_tip(tip_amount)
    transfer = Stripe::Transfer.create(recipient: stripe_id,
                                       amount: tip_amount * 100,
                                       currency: 'usd')
  rescue => e
    logger.error "Stripe error while creating transfer: #{e.message}"
    errors.add(:base, "There was a problem making the transfer.")
    false
  end

  def create_deposit_method(bank_info)
    if self.stripe_id
      method = self.build_deposit_method(last_four: bank_info[:account_number][-4..-1])
      method.save!
    else
      method = self.build_deposit_method(is_card: false)
      method.save!
    end
  end

  def update_deposit_method(bank_info)
    if self.stripe_id
      self.deposit_method.update(is_card: true, last_four: bank_info[:account_number][-4..-1])
    else
      self.deposit_method.update(is_card: false, last_four: nil)
    end
  end

end
