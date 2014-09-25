class AddPropertyIdToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :property_id, :integer
    add_index :invitations, :property_id
  end
end
