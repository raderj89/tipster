class UserInvitationMailer < ActionMailer::Base
  default from: "no-reply@tipster.nycdevshop.com"

  def property_admin_invite(invitation)
    @invitation = invitation
    mail to: invitation.recipient_email
  end

  def property_employee_invite(property, invitation)
    @invitation = invitation
    @property = property

    mail to: invitation.recipient_email
  end
end
