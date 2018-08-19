class AddOrgUnitToWidgets < ActiveRecord::Migration[5.2]
  def change
    add_column :widgets, :org_unit_id, :integer
  end
end
