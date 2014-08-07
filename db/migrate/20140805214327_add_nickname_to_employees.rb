class AddNicknameToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :nickname, :string
  end
end
