class CreateMagento2Customers < ActiveRecord::Migration[5.0]
  def change
    create_table :magento2_customers do |t|
      t.string :id_csv
      t.string :name
      t.string :email
      t.string :group
      t.string :phone
      t.string :zip
      t.string :country
      t.string :state
      t.string :customer_since
      t.string :web_site
      t.string :last_logged_in
      t.string :confirmed_email
      t.string :account_created_in
      t.string :billing_address
      t.string :shipping_address
      t.string :date_of_birth
      t.string :tax_vat_number
      t.string :gender
      t.string :street_address
      t.string :city
      t.string :fax
      t.string :vat_number
      t.string :company
      t.string :billing_firstname
      t.string :billing_lastname
      t.string :action
      t.timestamps
    end
  end
end
