class Transaction < ActiveRecord::Base

  # Callbacks
  before_create :set_total

  # Relations
  belongs_to :user
  belongs_to :property
  has_many :employee_tips, class_name: 'Tip', foreign_key: 'transaction_id'

  delegate :address, :full_address, :name, :city_state_zip, :picture_thumb, to: :property
  delegate :signature, :avatar_thumb, to: :user, prefix: true

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

  def total_in_cents
    total * 100
  end

  def pay
    if user.charge(total_in_cents)
      TipSender.new(self).send_tips
    else
      false
    end
  end

  private

    def set_total
      self.total = total_price
    end
end
