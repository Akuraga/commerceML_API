class CreateHandbooks < ActiveRecord::Migration[5.0]
  def change
    create_table :handbooks do |t|
      t.string :id_xml
      t.string :value
      t.integer :property_id
      t.timestamps
    end
  end
end
