class CreateWidgets < ActiveRecord::Migration[5.2]
  def change
    create_table :widgets do |t|
      t.string :name
      t.boolean :active
      t.integer :knx_module_id
      t.integer :room_id

      t.timestamps
    end
    add_index :widgets, :knx_module_id
    add_index :widgets, :room_id
  end
end
