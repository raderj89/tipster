class CreateTitles < ActiveRecord::Migration
  def change
    create_table :titles do |t|
      t.string :title, null: false
      t.integer :suggested_tip

      t.timestamps
    end
  end
end
