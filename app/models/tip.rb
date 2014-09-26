class Tip < ActiveRecord::Base
  belongs_to :user_transaction, class_name: 'Transaction', foreign_key: 'transaction_id'
  belongs_to :employee

  delegate :signature, to: :user_transaction
  delegate :stripe_id, :deposit_method, to: :employee, prefix: true

  validates :amount, presence: true

  self.per_page = 5

  def amount_to_cents
    amount * 100
  end

  def send_to_employee
    transfer = Stripe::Transfer.create(recipient: employee_stripe_id,
                                       amount: amount_to_cents,
                                       currency: 'usd')
    TransactionMailer.employee_receive_tips(tip).deliver
  rescue => e
    logger.error "Stripe error while creating transfer: #{e.message}"
    errors.add(:base, "There was a problem making the transfer.")
    false
  end
end
