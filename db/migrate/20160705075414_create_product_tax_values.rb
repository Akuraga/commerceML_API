class CreateProductTaxValues < ActiveRecord::Migration[5.0]
  def change
    create_table :product_tax_values do |t|
      t.integer :product_id
      t.integer :tax_id
      t.string :value
    end
  end
end
