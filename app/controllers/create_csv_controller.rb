class CreateCsvController < ApplicationController
  include ImportCsvFromSite
  include ExportCsvFromSite


  #парсим данные с сайта
  def csv_site_to_erp
    file_products = './data/from_site/catalog_product.csv'
    file_orders = './data/from_site/orders.csv'
    file_customers = './data/from_site/customers.csv'
    import_products(file_products)
    import_orders(file_orders)
    import_customers(file_customers)
    render text: "all ok csv_site_to_erp"
  end



  def csv_erp_to_site
    file_products = './data/to_site/catalog_product.csv'
    file_orders = './data/to_site/orders.csv'
    file_customers = './data/to_site/customers.csv'
    export_products(file_products)
    #export_orders(file_orders)
    #export_customers(file_customers)
    render text: "all ok csv_erp_to_site"
  end

end
