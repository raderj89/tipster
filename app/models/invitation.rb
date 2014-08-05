class Invitation < ActiveRecord::Base

  # Relations
  belongs_to :sender, polymorphic: true

  # Callbacks
  before_create :generate_token

  # Email regex
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # Validations
  validates :recipient_email, presence: true, length: { maximum: 100 },
            format: { with: VALID_EMAIL_REGEX }

  private

    def generate_token
      self.token = SecureRandom.urlsafe_base64
    end

end
