class CreateProductProperties < ActiveRecord::Migration[5.0]
  def change
    create_table :product_properties do |t|
      t.integer :product_id
      t.integer :property_id
      t.string :value
      t.timestamps
    end
  end
end
