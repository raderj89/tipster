class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.integer :tip_average 
      t.boolean :is_admin, default: false, null: false

      t.timestamps
    end
  end
end
