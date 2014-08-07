class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :name
      t.string :address, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip, null: false

      t.timestamps
    end
  end
end
