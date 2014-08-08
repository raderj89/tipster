class CreateEmployeeAddresses < ActiveRecord::Migration
  def change
    create_table :employee_addresses do |t|
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :state
      t.string :zip
      t.references :employee, index: true

      t.timestamps
    end
  end
end
