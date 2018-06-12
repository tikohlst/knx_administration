class CreateAdministrates < ActiveRecord::Migration[5.2]
  def change
    create_table :administrates do |t|
      t.integer :user_id
      t.integer :room_id

      t.timestamps
    end
    add_index :administrates, :user_id
    add_index :administrates, :room_id
  end
end
