class RequestBuilding < ActionMailer::Base
  default from: "no-reply@tipster.com"

  def request_signup(message, property)
    @message = message
    @property = property

    mail to: Admin.first.email, subject: "New building signup request"
  end
end
