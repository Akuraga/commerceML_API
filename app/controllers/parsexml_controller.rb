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
  require 'net/http'




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
      file_path = "./data/from_ERP/"
      if file_name.split('/')[0] == 'import_files'
        Dir.mkdir("#{file_path}#{file_name.split('/')[0]}")
        Dir.mkdir("#{file_path}#{file_name.split('/')[0]}/#{file_name.split('/')[1]}")
      end
      File.new("#{file_path}#{file_name}", "w")
      uploaded_io = request.body

      if uploaded_io != nil
        File.open(Rails.root.join(file_path, file_name), 'wb') do |file|
          file.write(uploaded_io.read)
        end
      else
        render plain: "failure"
      end

      render plain: "success"


    end

    #обрабатываем файлы полученые от сервера
    if type == 'catalog' and mode == 'import'
      if file_name.scan('import').size > 0
        parser_product_from_erp(file_name)
      elsif file_name.scan('offers').size > 0
        parser_offers_from_erp(file_name)
      end
      render plain: "success"
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
      render plain: "#{zip}\n#{file_limit}"
    end

    def send_order_to_erp
      # file = "./data/to_ERP/to.xml"
      #
      # # order =  create_order_to_erp
      # # to_erp = File.new(file, "w")
      # # File.write(to_erp, order.to_xml(:encoding => "UTF-8"))
      #
      # #url1 =  "http://#{request.remote_ip}#{request.port_string}/1c_exchange"
      # url1 =  "http://#{request.remote_ip}"
      #
      #  #url1 =  "http://192.168.1.38:80/1c_exchange?type=sale&mode=file&filename=to.xml"
      #  #RestClient.post(url1, :file => File.new(file))


    end


end
