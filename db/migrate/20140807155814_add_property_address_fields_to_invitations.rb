class AddPropertyAddressFieldsToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :property_name, :string
    add_column :invitations, :property_address, :string
    add_column :invitations, :property_city, :string
    add_column :invitations, :property_state, :string
    add_column :invitations, :property_zip, :string
  end
end
