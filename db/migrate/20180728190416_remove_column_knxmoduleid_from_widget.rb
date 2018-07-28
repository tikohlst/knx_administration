class RemoveColumnKnxmoduleidFromWidget < ActiveRecord::Migration[5.2]
  def up
    remove_column :widgets, :knx_module_id
  end
  def down
    add_column :widgets, :knx_module_id, :integer
  end
end
