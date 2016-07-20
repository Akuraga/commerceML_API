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




  FILE_PATH_CATALOGS_OFFERS =  "./data/from_ERP/"
  FILE_PATH_ORDER_FROM_ERP = "./data/from_ERP/"
  FILE_PATH_ORDER_TO_ERP = "./data/to_ERP/"


  require 'rest-client'
  def parse_my_doc
    file_name = './data/from_ERP/import.xml'
    file_name2 = './data/from_ERP/offers.xml'
    file_name3 = './data/from_ERP/orders.xml'
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
    file_path_order = "./data/from_ERP/"
    file_path_catalogs_offers = "./data/from_ERP/"

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
      if file_name.split('/')[0] == 'import_files'
        begin
          Dir.mkdir("#{FILE_PATH_CATALOGS_OFFERS}#{file_name.split('/')[0]}")
        rescue
        end
        begin
          Dir.mkdir("#{FILE_PATH_CATALOGS_OFFERS}#{file_name.split('/')[0]}/#{file_name.split('/')[1]}")
        rescue
        end
      end
      File.new("#{FILE_PATH_CATALOGS_OFFERS}#{file_name}", "w")
      uploaded_io = request.body

      if uploaded_io != nil
        File.open(Rails.root.join(FILE_PATH_CATALOGS_OFFERS, file_name), 'wb') do |file|
          file.write(uploaded_io.read)
        end
      else
        render plain: "failure"
      end

      render plain: "success"
    end

    #обрабатываем файлы полученые от сервера
    if type == 'catalog' and mode == 'import'
      if file_name.scan(/import[\d]*.xml/).size > 0
        # parser_product_from_erp(FILE_PATH_CATALOGS_OFFERS + file_name)
      elsif file_name.scan('offers').size > 0
        # parser_offers_from_erp(FILE_PATH_CATALOGS_OFFERS + file_name)
      elsif file_name.scan('oreders').size > 0
        # parse_order_from_erp(FILE_PATH_CATALOGS_OFFERS + file_name)
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
        File.new("#{FILE_PATH_ORDER_FROM_ERP}#{file_name}", "w")
        uploaded_io = request.body
        if uploaded_io != nil
          File.open(Rails.root.join(FILE_PATH_ORDER_FROM_ERP, file_name), 'wb') do |file|
            file.write(uploaded_io.read)
          end
          parse_order_from_erp(FILE_PATH_CATALOGS_OFFERS + file_name)
          render plain: "success"
        else
          render plain: "failure"
        end
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
      # parse_order_from_erp(FILE_PATH_ORDER_FROM_ERP + "orders.xml")
      to_erp = File.read('./data/from_ERP/orders.xml')
      order =  create_order_to_erp
      # "http://#{request.remote_ip}"

      # s = StringIO.new(to_erp.to_s)
      # RestClient.post "http://#{request.remote_ip}:8080/", s, :content_type => 'application/octet-stream'
      # RestClient.post "http://192.168.1.35:3001/1c_exchange", order.to_xml(:encoding => "UTF-8"), :content_type => 'application/octet-stream', timeout: 10
      # RestClient.post '192.168.1.38:80', order.to_xml(:encoding => "UTF-8"), :content_type => :json, :accept => :json#'application/octet-stream'
      begin
        RestClient.post request.remote_ip, order.to_xml(:encoding => "UTF-8"), :content_type => 'application/atom+xml'
      rescue => error
      a=2
      end

      # site = RestClient::Resource.new('192.168.1.38', :headers => {
      # :content_type => 'application/atom+xml',
      # :'DataServiceVersion' => '3.0;NetFx',
      # :'MaxDataServiceVersion' =>'3.0;NetFx',
      # :'Accept' =>'application/atom+xml,application/xml',
      # :'Authorization' => request.authorization,
      # :'Accept-Charset' => request.accept_encoding,
      # :'User-Agent' => request.user_agent,
      # :'Host' => "#{request.host}"
      # })
      # site.post order.to_xml(:encoding => "UTF-8")
    end

end
