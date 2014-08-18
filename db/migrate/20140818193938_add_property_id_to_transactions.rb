class AddPropertyIdToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :property_id, :integer, null: false
    add_index :transactions, :property_id
  end
end
