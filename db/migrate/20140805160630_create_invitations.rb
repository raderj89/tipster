class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :recipient_email, null: false
      t.string :token, null: false
      t.references :sender, polymorphic: true, null: false
      t.string :position

      t.timestamps
    end
  end
end
