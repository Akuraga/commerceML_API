class ParsexmlController < ApplicationController
  include AddAddress
  include AddressParser
  include CatalogParser
  include ClassifierParser
  include CommercemlParser
  include OffersParser
  include OrderParser
  include ToErpOrder

  def index
    # file_xml = './data/from_ERP/import.xml'
    # file_offers = './data/from_ERP/offers.xml'
    # file_order = './data/from_ERP/orders.xml'
    #
    # parser_product_from_erp(file_xml)
    # parser_offers_from_erp(file_offers)
    # parse_order_from_erp(file_order)

    #create_order_to_erp
  end


  def exchange_1c
    # http://v8.1c.ru/edi/edi_stnd/131/#2
    # A. Начало сеанса
      #
      # Выгрузка данных начинается с того, что система "1С:Предприятие" отправляет http-запрос следующего вида:
      # http://<сайт>/<путь> /1c_exchange.php?type=sale&mode=checkauth.
      # В ответ система управления сайтом передает системе «1С:Предприятие» три строки (используется разделитель строк "\n"):
      # слово "success";
      # имя Cookie;
      # значение Cookie.
      # Примечание. Все последующие запросы к системе управления сайтом со стороны "1С:Предприятия" содержат в заголовке запроса имя и значение Cookie.

    # B. Уточнение параметров сеанса
      #
      # Далее следует запрос следующего вида:
      # http://<сайт>/<путь> /1c_exchange.php?type=sale&mode=init
      #
      # В ответ система управления сайтом передает две строки:
      # 1. zip=yes, если сервер поддерживает обмен в zip-формате -  в этом случае на следующем шаге файлы должны быть упакованы в zip-формате
      # или
      # zip=no - в этом случае на следующем шаге файлы не упаковываются и передаются каждый по отдельности.
      # 2. file_limit=<число>, где <число> - максимально допустимый размер файла в байтах для передачи за один запрос. Если системе "1С:Предприятие" понадобится передать файл большего размера, его следует разделить на фрагменты.

    # C. Получение файла обмена с сайта (от системы)
      #
      # Затем на сайт отправляется запрос вида
      # http://<сайт>/<путь> /1c_exchange.php?type=sale&mode=query.
      # Сайт передает сведения о заказах в формате CommerceML 2. В случае успешного получения и записи заказов "1С:Предприятие" передает на сайт запрос вида
      # http://<сайт>/<путь> /1c_exchange.php?type=sale&mode=success

    # D. Отправка файла обмена на сайт
    # Затем система "1С:Предприятие" отправляет на сайт запрос вида
    # http://<сайт>/<путь> /1c_exchange.php?type=sale&mode=file&filename=<имя файла>,
    # который загружает на сервер файл обмена, посылая содержимое файла в виде POST.
    # В случае успешной записи файла система управления сайтом передает строку со словом "success". Дополнительно на следующих строчках могут содержаться замечания по загрузке.
    # Примечание. Если в ходе какого-либо запроса произошла ошибка, то в первой строке ответа системы управления сайтом будет содержаться слово "failure", а в следующих строках - описание ошибки, произошедшей в процессе обработки запроса.
    # Если произошла необрабатываемая ошибка уровня ядра продукта или sql-запроса, то будет возвращен html-код.






    # константы ответа 1С
    cookie = 'NAME'
    cookie_value = 'admin'
    zip = 'no'
    file_limit = 52428800



    type      = params[:type]
    mode      = params[:mode]
    file_name =  params[:filename]

    if type == 'sale' and mode == 'checkauth'
      first_response(cookie, cookie_value)
    end

    if type == 'sale' and mode == 'init'
      second_response(zip, file_limit)
    end

    if type == 'sale' and mode == 'query'
      send_order_to_erp
    end

    #обработка входящего файла с заказами от 1С
      if type == 'sale' and mode == 'file'
        parse_order_from_erp(file_name)
        render text: "success"
      end


    #подтверждение, от 1С, успешного приема файла с заказами
      if type == 'sale' and mode == 'success'
      end

  end

  private
    def first_response(cookie, cookie_value)
      render html: "success\n#{cookie}\n#{cookie_value}\n"
      #render text: "success\n"
    end

    def second_response(zip, file_limit)
      render text: "#{zip}\n#{file_limit}\n"
    end

    def send_order_to_erp
      render xml: create_order_to_erp
    end


end
