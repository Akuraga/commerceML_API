class CreatePriceTypeTaxValues < ActiveRecord::Migration[5.0]
  def change
    create_table :price_type_tax_values do |t|
      t.integer :price_type_id
      t.integer :tax_id
      t.string :value
      t.timestamps
    end
  end
end
