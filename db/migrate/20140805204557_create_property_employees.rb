class CreatePropertyEmployees < ActiveRecord::Migration
  def change
    create_table :property_employees do |t|
      t.references :employee, index: true, null: false
      t.references :property, index: true, null: false
      t.references :title, index: true, null: false

      t.timestamps
    end
  end
end
