class TransactionMailer < ActionMailer::Base
  default from: "no-reply@tipster.nycdevshop.com"

  def user_transaction(user)
    mail(to: user.email, subject: 'Thanks for Tipping!')
  end

  def employee_receive_tips(tip)
    @tip = tip
    mail(to: tip.employee.email, subject: 'You just received tips!')
  end
end
