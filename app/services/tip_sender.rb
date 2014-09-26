class TipSender

  attr_reader :transaction

  def initialize(transaction)
    @transaction = transaction
  end

  def send_tips
    send_tips_by_stripe
    send_tips_by_mail
  end

  def send_tips_by_stripe
    transaction.employee_tips.each do |tip|
      if tip.employee_deposit_method && tip.employee_deposit_method.is_bank
        tip.send_to_employee
      end
    end
  end

  def send_tips_by_mail
    tips_to_mail = collect_tips_to_mail.compact!
    if tips_to_mail.size > 0
      AdminSendTips.tips_to_send_by_mail(tips_to_mail).deliver
    end
  end

  def collect_tips_to_mail
    transaction.employee_tips.map do |tip|
      tip if !tip.employee_deposit_method.nil? && tip.employee_deposit_method.is_bank == false
    end
  end

end