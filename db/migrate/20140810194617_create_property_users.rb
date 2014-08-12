class CreatePropertyUsers < ActiveRecord::Migration
  def change
    create_table :property_users do |t|
      t.references :user
      t.references :property

      t.timestamps
    end
  end
end
