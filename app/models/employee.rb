class Employee < ActiveRecord::Base

  # Relations
  has_many :positions, class_name: 'PropertyEmployee', foreign_key: 'employee_id', inverse_of: :employee
  has_many :properties, through: :positions
  has_one :address, class_name: 'EmployeeAddress', foreign_key: 'employee_id'
  belongs_to :invitation
  has_many :sent_invitations, as: :sender, class_name: 'Invitation', foreign_key: 'sender_id'

  # Nested Attributes
  accepts_nested_attributes_for :positions

  # Email regex
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # Validations
  validates :first_name, presence: true, length: { maximum: 100}
  validates :last_name, presence: true, length: { maximum: 100}
  validates :email, presence: true, length: { maximum: 100}, format: { with: VALID_EMAIL_REGEX }
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
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating recipient: #{e.message}"
    errors.add(:base, "There was a problem with your bank information.")
    false
  end

end
