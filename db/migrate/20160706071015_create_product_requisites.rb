class CreateProductRequisites < ActiveRecord::Migration[5.0]
  def change
    create_table :product_requisites do |t|
      t.integer :product_id
      t.integer :requisite_id
      t.string :value
      t.timestamps
    end
  end
end
