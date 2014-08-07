class Employee < ActiveRecord::Base

  # Relations
  has_many :positions, class_name: 'PropertyEmployee', foreign_key: 'employee_id'
  has_many :properties, through: :positions
  belongs_to :invitation
  has_many :sent_invitations, as: :sender, class_name: 'Invitation', foreign_key: 'sender_id'

  # Email regex
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # Validations
  validates :first_name, presence: true, length: { maximum: 100}
  validates :last_name, presence: true, length: { maximum: 100}
  validates :email, presence: true, length: { maximum: 100}, format: { with: VALID_EMAIL_REGEX }
  validates :password, length: { minimum: 6 }

  # Paperclip
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  # BCrypt
  has_secure_password

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

end
