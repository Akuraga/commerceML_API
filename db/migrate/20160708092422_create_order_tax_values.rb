class CreateOrderTaxValues < ActiveRecord::Migration[5.0]
  def change
    create_table :order_tax_values do |t|
      t.integer :product_id
      t.integer :tax_id
      t.string :in_total
      t.string :sum
      t.string :rate
      t.timestamps
    end
  end
end

