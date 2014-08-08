class AddStripeIdToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :stripe_id, :string
  end
end
