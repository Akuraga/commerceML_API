class CreateProductAttributeValues < ActiveRecord::Migration[5.0]
  def change
    create_table :product_attribute_values do |t|
      t.integer :product_attribute_id
      t.integer :product_id
      t.string :value
      t.timestamps
    end
  end
end
