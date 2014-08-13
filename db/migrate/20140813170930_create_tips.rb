class CreateTips < ActiveRecord::Migration
  def change
    create_table :tips do |t|
      t.integer :amount
      t.references :transaction, index: true
      t.references :employee, index: true
      t.text :message

      t.timestamps
    end
  end
end
