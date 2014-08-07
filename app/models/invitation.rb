class Invitation < ActiveRecord::Base

  # Relations
  belongs_to :sender, polymorphic: true

  # Callbacks
  before_create :generate_token
  after_create :send_invitation_email

  # Email regex
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # Validations
  validates :recipient_email, presence: true, length: { maximum: 100 },
            format: { with: VALID_EMAIL_REGEX }

  private

    # Generate url-safe invitation token
    def generate_token
      self.token = SecureRandom.urlsafe_base64
    end

    # Send invitation email
    def send_invitation_email
      UserInvitationMailer.confirm_invite(self).deliver
    end

end
