class CreateKnxModules < ActiveRecord::Migration[5.2]
  def change
    create_table :knx_modules do |t|
      t.string :name

      t.timestamps
    end
  end
end
