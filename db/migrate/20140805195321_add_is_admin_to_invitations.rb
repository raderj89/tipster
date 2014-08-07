class AddIsAdminToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :is_admin, :boolean, default: false
    add_index :invitations, :recipient_email
  end
end
