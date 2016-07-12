class CreateProperties < ActiveRecord::Migration[5.0]
  def change
    create_table :properties do |t|
      t.integer :classifier_id
      t.string :id_xml
      t.string :name
      t.string :value
      t.string :for_product
      t.timestamps
    end
  end
end
