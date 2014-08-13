class Admin < ActiveRecord::Base

  # Callbacks
  before_save { self.email = email.downcase }

  # Email regex
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # Validations
  validates :email, presence: true, length: { maximum: 100 },
            format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 },
            unless: Proc.new { |a| a.password.blank? }

  # Relations
  has_many :invitations, as: :sender, dependent: :delete_all

  # BCrypt
  has_secure_password
end
