class CreateMagento2Orders < ActiveRecord::Migration[5.0]
  def change
    create_table :magento2_orders do |t|
      t.string :id_csv
      t.string :purchase_point
      t.string :purchase_date
      t.string :bill_name
      t.string :ship_name
      t.string :grand_total_base
      t.string :grand_total_purchased
      t.string :status
      t.string :billing_address
      t.string :shipping_address
      t.string :shipping_information
      t.string :customer_email
      t.string :customer_group
      t.string :subtotal
      t.string :shipping_handling
      t.string :customer_name
      t.string :payment_method
      t.string :total_refunded
      t.string :action
      t.timestamps
    end
  end
end
