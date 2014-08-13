class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :user, index: true
      t.string :total
      t.float :total

      t.timestamps
    end
  end
end
