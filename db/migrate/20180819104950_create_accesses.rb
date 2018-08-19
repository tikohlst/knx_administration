class CreateAccesses < ActiveRecord::Migration[5.2]
  def change
    create_table :accesses do |t|
      t.belongs_to :user, index: true
      t.belongs_to :org_unit, index: true
      t.datetime :appointment_date
      t.timestamps
    end
  end
end
