class AddInvitationIdOnEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :invitation_id, :integer, null: false
    add_index :employees, :invitation_id
  end
end
