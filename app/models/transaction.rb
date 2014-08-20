class Transaction < ActiveRecord::Base

  # Callbacks
  before_create :set_total

  # Relations
  belongs_to :user
  belongs_to :property
  has_many :employee_tips, class_name: 'Tip', foreign_key: 'transaction_id'

  delegate :address, :full_address, :name, :city_state_zip, :picture_thumb, to: :property
  delegate :signature, :avatar_thumb, to: :user

  # Nested attributes
  accepts_nested_attributes_for :employee_tips, reject_if: proc { |attributes| attributes['amount'].blank? }

  # Scopes
  default_scope { order('created_at DESC' ) }

  # Pagination
  self.per_page = 5

  # Methods
  def total_price
    employee_tips.to_a.sum { |tip| tip.amount }
  end

  def set_total
    self.total = total_price
  end

  def pay
    if user.charge(self.total)
      send_out_tips
    else
      false
    end
  end

  private

    def send_out_tips
      employee_tips.each do |tip|
        if tip.employee.deposit_method && tip.employee.deposit_method.is_card
          tip.employee.send_tip(tip.amount)
        end
      end

      tips_to_mail = employee_tips.map { |tip| tip if !tip.employee.deposit_method.nil? && tip.employee.deposit_method.is_card == false }
      tips_to_mail.compact!
      AdminSendTips.tips_to_send_by_mail(tips_to_mail).deliver
    end
end
