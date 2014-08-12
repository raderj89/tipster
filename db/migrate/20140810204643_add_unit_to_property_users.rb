class AddUnitToPropertyUsers < ActiveRecord::Migration
  def change
    add_column :property_users, :unit, :string
  end
end
