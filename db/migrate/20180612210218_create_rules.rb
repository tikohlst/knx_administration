class CreateRules < ActiveRecord::Migration[5.2]
  def change
    create_table :rules do |t|
      t.string :name
      t.boolean :status
      t.integer :start_value
      t.integer :end_value
      t.float :steps
      t.integer :widget_id

      t.timestamps
    end
    add_index :rules, :widget_id
  end
end
