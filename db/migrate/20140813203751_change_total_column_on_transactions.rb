class ChangeTotalColumnOnTransactions < ActiveRecord::Migration
  def change
    change_column :transactions, :total, :integer
  end
end
