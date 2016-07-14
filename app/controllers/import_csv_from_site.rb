module ImportCsvFromSite
  require 'csv-mapper'
  include CsvMapper


  def import_products(file)
    CSV.foreach(file, :headers => true) do |row|
      Magento2CatalogProduct.create!(row.to_hash)
    end
  end


  def import_orders(file)


    import(file) do
      map_to Magento2Order
      after_row lambda{|row, magento2order| magento2order.save }

      start_at_row 1
      [id_csv, purchase_point, purchase_date, bill_name, ship_name, grand_total_base, grand_total_purchased, status,
       billing_address, shipping_address, shipping_information, customer_email, customer_group, subtotal,
       shipping_handling, customer_name, payment_method, total_refunded, action]
    end

  end


  def import_customers(file)
    import(file) do
      map_to Magento2Customer
      after_row lambda{|row, magento2customer| magento2customer.save }

      start_at_row 1
      [id_csv, name, email, group, phone, zip, country, state, customer_since, web_site, last_logged_in, confirmed_email,
       account_created_in, billing_address, shipping_address, date_of_birth, tax_vat_number, gender,
       street_address, city, fax, vat_number, company, billing_firstname, billing_lastname, action]
    end
  end

end