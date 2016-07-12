class CreateDocumentsProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :documents_products do |t|
      t.integer :document_id
      t.integer :product_id
      t.string :price
      t.string :quantity
      t.string :sum
      t.string :unit
      t.string :coefficient
      t.timestamps
    end
  end
end
