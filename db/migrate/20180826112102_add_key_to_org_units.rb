class AddKeyToOrgUnits < ActiveRecord::Migration[5.2]
  def change
    add_column :org_units, :key, :string
  end
end
