class ProductAttributesProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :product_attributes_products, id: false do |t|
      t.integer :product_attribute_id
      t.integer :product_id
    end
  end
end
