class CreatePropertyEmployees < ActiveRecord::Migration
  def change
    create_table :property_employees do |t|
      t.references :employee, index: true, null: false
      t.references :property, index: true, null: false
      t.string :title, null: false, default: ""
      t.integer :suggested_tip, null: false, default: 0

      t.timestamps
    end
  end
end
