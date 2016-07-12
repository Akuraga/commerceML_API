class HandbooksProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :handbooks_products, id: false do |t|
      t.integer :handbook_id
      t.integer :product_id
    end
  end
end
