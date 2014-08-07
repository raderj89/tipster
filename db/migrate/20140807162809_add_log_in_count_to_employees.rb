class AddLogInCountToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :log_in_count, :integer
  end
end
