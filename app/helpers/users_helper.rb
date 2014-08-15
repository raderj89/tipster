module UsersHelper

  def transaction_date(transaction)
    transaction.created_at.strftime("%-m/%-d/%Y")
  end
end
