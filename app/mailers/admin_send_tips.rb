class AdminSendTips < ActionMailer::Base
  default from: "no-reply@tipster.com"

  def tips_to_send_by_mail(tips)
    @tips = tips

    mail to: Admin.first.email
  end
end
