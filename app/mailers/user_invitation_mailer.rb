class UserInvitationMailer < ActionMailer::Base
  default from: "no-reply@tipster.nycdevshop.com"

  def confirm_invite(invitation)
    @invitation = invitation
    mail to: invitation.recipient_email
  end
end
