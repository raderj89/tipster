class CreateDepositMethods < ActiveRecord::Migration
  def change
    create_table :deposit_methods do |t|
      t.string :last_four
      t.boolean :is_card, default: true
      t.references :employee, index: true

      t.timestamps
    end
  end
end
