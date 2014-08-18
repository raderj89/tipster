class Tip < ActiveRecord::Base
  belongs_to :user_transaction, class_name: 'Transaction', foreign_key: 'transaction_id'
  belongs_to :employee

  delegate :signature, to: :user_transaction

  validates :amount, presence: true

  self.per_page = 5
end
