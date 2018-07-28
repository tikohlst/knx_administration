class RemoveColumnRoomidFromWidget < ActiveRecord::Migration[5.2]
  def up
    remove_column :widgets, :room_id
  end
  def down
    add_column :widgets, :room_id, :integer
  end
end
