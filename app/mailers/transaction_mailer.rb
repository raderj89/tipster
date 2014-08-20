class TransactionMailer < ActionMailer::Base
  default from: "no-reply@tipster.nycdevshop.com"

  def user_transaction(user)
    mail(to: user.email, subject: 'Thanks for Tipping!')
  end

  def employee_receive_tips(employee)
    mail(to: employee.email, subject: 'You just received tips!')
  end
end
