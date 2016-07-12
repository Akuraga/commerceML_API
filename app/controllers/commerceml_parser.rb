module CommercemlParser

  def parser_product_from_erp
    file_xml = './data/from_ERP/import.xml'
    file_offers = './data/from_ERP/offers.xml'

    #парсинг файла import.xml
      xml_doc = Nokogiri::XML(File.open(file_xml))

      @new_commerce_information               = CommerceInformation.new
      @new_commerce_information.version       = xml_doc.css('КоммерческаяИнформация')[0]['ВерсияСхемы']
      @new_commerce_information.date          = xml_doc.css('КоммерческаяИнформация')[0]['ДатаФормирования']
      @new_commerce_information.name_document = "from_ERP_import"
      @new_commerce_information.from_erp = true
      @new_commerce_information.save!

      if xml_doc.css('Классификатор')
        parse_classifier(xml_doc.css('Классификатор'), @new_commerce_information)
      end

      if xml_doc.css('Каталог')
        parse_catalog(xml_doc.css('Каталог'), @new_commerce_information)
      end

    #парсинг файла offers.xml
      offers_doc = Nokogiri::XML(File.open(file_offers))

      @new_commerce_information               = CommerceInformation.new
      @new_commerce_information.version       = offers_doc.css('КоммерческаяИнформация')[0]['ВерсияСхемы']
      @new_commerce_information.date          = offers_doc.css('КоммерческаяИнформация')[0]['ДатаФормирования']
      @new_commerce_information.name_document = "from_ERP_offers"
      @new_commerce_information.from_erp = true
      @new_commerce_information.save!

      if offers_doc.css('ПакетПредложений')
        parse_offer(offers_doc, @new_commerce_information)
      end
  end


  #парсинг файла заказов из ERP системы    .xml


  def parse_order_from_erp()
    file = './data/from_ERP/orders.xml'
    #file = './data/from_site/from.xml'
    order_doc = Nokogiri::XML(File.open(file))

    @new_commerce_information               = CommerceInformation.new
    @new_commerce_information.version       = order_doc.css('КоммерческаяИнформация')[0]['ВерсияСхемы']
    @new_commerce_information.date          = order_doc.css('КоммерческаяИнформация')[0]['ДатаФормирования']
    @new_commerce_information.name_document = "from_ERP_order"
    @new_commerce_information.from_erp = true
    @new_commerce_information.save!

    if order_doc.css('Документ')
      parse_order(order_doc, @new_commerce_information)
    end
  end




end