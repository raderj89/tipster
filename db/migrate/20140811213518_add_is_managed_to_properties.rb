class AddIsManagedToProperties < ActiveRecord::Migration
  def up
    change_table :properties do |t|
      t.boolean :is_managed, default: false
    end
    Property.update_all ["is_managed = ?", false]
  end

  def down
    remove_column :properties, :is_managed
  end
end
