class ParsexmlController < ApplicationController
  include AddAddress
  include AddressParser
  include CatalogParser
  include ClassifierParser
  include CommercemlParser
  include OffersParser
  include OrderParser
  include ToErpOrder
  include ToSite

  require 'rest-client'
  def parse_my_doc
    file_name = './data/from_ERP/example/import.xml'
    file_name2 = './data/from_ERP/example/offers.xml'
    file_name3 = './data/from_ERP/example/orders.xml'
    parser_product_from_erp(file_name)
    parser_offers_from_erp(file_name2)
    parse_order_from_erp(file_name3)
    render text: "ok"
  end


  def exchange_1c

    # константы ответа 1С
    cookie = 'NAME'
    cookie_value = 'admin'
    zip = 'no'
    file_limit = 52428800


    type      = params[:type]
    mode      = params[:mode]
    file_name =  params[:filename]


    #проверка связи
    if type == 'catalog' and mode == 'checkauth'
      first_response(cookie, cookie_value)
    end

    # инициализация настроек
    if type == 'catalog' and mode == 'init'
      second_response(zip, file_limit)
    end

    #сохраняем файлы каталогов полученые от сервера
    if type == 'catalog' and mode == 'file'
      # import_file = File.new("./data/from_ERP/#{file_name}", "w")
      # file = params[:content]

      # uploaded_io = params[:filename]
      # # import_file.write(uploaded_io.read)
      #
      # if uploaded_io != nil
      #   File.open(Rails.root.join('public', 'uploads', "#{file_name}"), 'wb') do |file|
      #     file.write(uploaded_io.read)
      #   end
      # end

      render text: "success"
      #parser_product_from_erp(file_name)
    end

    #обрабатываем файлы полученые от сервера
    if type == 'catalog' and mode == 'import'
      if file_name == "import.xml" #обработать иморт если фал не один
        #parser_product_from_erp(file_name)
      elsif file_name == "offers.xml"
        parser_offers_from_erp(file_name)
      end

      render text: "success"
    end



    if type == 'sale' and mode == 'checkauth'
      first_response(cookie, cookie_value)
    end

    if type == 'sale' and mode == 'init'
      second_response(zip, file_limit)
    end

    #создание файла с заказами и отправка его 1С
    if type == 'sale' and mode == 'query'
      send_order_to_erp
    end

    #обработка входящего файла с заказами от 1С
      if type == 'sale' and mode == 'file'
         parse_order_from_erp(file_name)
         render plain: "success"
      end


    #подтверждение, от 1С, успешного приема файла с заказами
      if type == 'sale' and mode == 'success'
        a=2
      end

  end

  private
    def first_response(cookie, cookie_value)
      render plain: "success"
    end

    def second_response(zip, file_limit)
      render text: "#{zip}\n#{file_limit}\n"
    end

    def send_order_to_erp
       file = "./data/to_ERP/to_erp.xml"
      # order =  create_order_to_erp
      # to_erp = File.new(file, "w")
      # File.write(to_erp, order.to_xml(:encoding => "UTF-8"))

      RestClient.post("192.168.1.36:1560",
                      {:upload => {:file => File.new(file, 'rb')}
                      })
    end


end
