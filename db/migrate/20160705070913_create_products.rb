class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :id_xml
      t.string :barcode      #штрих код
      t.string :vendorcode   #артикул
      t.string :name
      t.integer :catalog_id
      t.integer :unit_id
      t.timestamps
    end
  end
end
