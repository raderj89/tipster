class TipSender

  attr_reader :transaction

  def initialize(transaction)
    @transaction = transaction
  end

  def transfer_money
    tips_to_mail = []

    transfer.employee_tips.each do |tip|
      if tip.employee_has_bank_deposit?
        send_tip(tip)
        tip.employee.send_tip(tip.amount)
      else
        employees_accepting_tip_by_mail << tip
    end

    tips_to_mail = employee_tips.map { |tip| tip if !tip.employee.deposit_method.nil? && tip.employee.deposit_method.is_card == false }
    tips_to_mail.compact!
    AdminSendTips.tips_to_send_by_mail(tips_to_mail).deliver
  end

  def send_tip(tip)
    transfer = Stripe::Transfer.create(recipient: stripe_id, amount: tip_amount * 100, currency: 'usd')
  rescue => e
    logger.error "Stripe error while creating transfer: #{e.message}"
    errors.add(:base, "There was a problem making the transfer.")
    false
  end

end