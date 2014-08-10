class AddFullAddressToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :full_address, :text
  end
end
