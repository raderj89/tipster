class Transaction < ActiveRecord::Base

  # Callbacks
  after_create :send_out_tips

  # Relations
  belongs_to :user
  belongs_to :property
  has_many :employee_tips, class_name: 'Tip', foreign_key: 'transaction_id'

  delegate :address, :full_address, :name, :city_state_zip, :picture_thumb, to: :property
  delegate :signature, to: :user

  # Nested attributes
  accepts_nested_attributes_for :employee_tips, reject_if: proc { |attributes| attributes['amount'].blank? }

  # Methods
  def total_price
    employee_tips.to_a.sum { |tip| tip.amount }
  end

  def pay_and_save
    self.total = total_price
    if user.charge(self.total)
      save!
    else
      false
    end
  end

  private

    def send_out_tips
      employee_tips.each do |tip|
        tip.employee.send_tip(tip.amount)
      end
    end
end
