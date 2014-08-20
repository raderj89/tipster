class CreatePaymentMethods < ActiveRecord::Migration
  def change
    create_table :payment_methods do |t|
      t.string :card_type
      t.string :last_four
      t.references :user, index: true

      t.timestamps
    end
  end
end
