class AddValueToWidgets < ActiveRecord::Migration[5.2]
  def change
    add_column :widgets, :value, :float
  end
end
