class Tip < ActiveRecord::Base
  belongs_to :user_transaction, class_name: 'Transaction', foreign_key: 'transaction_id'
  belongs_to :employee

  validates :amount, presence: true
end
