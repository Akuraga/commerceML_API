class ParsexmlController < ApplicationController
  include AddAddress
  include AddressParser
  include CatalogParser
  include ClassifierParser
  include CommercemlCreator
  include CommercemlParser
  include OffersParser
  include OrderParser
  include ToErpOrder

  def index

    #parser_product_from_erp
    #parse_order_from_erp

    #create_order_to_erp
  end


  def exchange_1c
    asd = params[]
    @to_site = create_order_to_erp
    render xml: @to_site
  end

end
