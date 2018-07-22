class AddUseToWidgets < ActiveRecord::Migration[5.2]
  def change
    add_column :widgets, :use, :string
  end
end
