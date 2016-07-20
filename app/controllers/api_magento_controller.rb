class ApiMagentoController < ApplicationController
  include WriteLogFile


  before_action :autorization, only: :ask_from_1c

  def ask_from_1c
    add_product_to_magento2
  end

  private
    def autorization
      #отримання token
      @token_key = RestClient.post "http://demo.beta.qpard.com/index.php/rest/V1/integration/admin/token", {"username":USERNAME_ADMIN_MAGENTO, "password":PASSWORD_ADMIN_MAGENTO}.to_json,
                               {:content_type => :json, :accept => :json}
    end


    def add_product_to_magento2
      begin
        result_categories = JSON.parse(RestClient.get "http://demo.beta.qpard.com/index.php/rest/V1/categories",
                                {:Authorization => "Bearer #{@token_key.to_s.gsub('"','')}", :content_type => :json, :accept => :json})
      rescue => error
        puts_log_file("log_add_product_to_magento2", "ERROR:#{error}", "Фігня в гет запиті до каталогу 'categories' маженти")
      end

      begin
        result_attribute_set = JSON.parse(RestClient.get "http://demo.beta.qpard.com/index.php/rest/V1/products/attribute-sets/sets/list?searchCriteria=''",
                                                         {:Authorization => "Bearer #{@token_key.to_s.gsub('"','')}", :content_type => :json, :accept => :json})
      rescue => error
        puts_log_file("log_add_product_to_magento2", "ERROR: #{error}", "Фігня в гет запиті до каталогу 'attribute-sets' маженти")
      end

      Product.where(in_out: "from_ERP").each do |product|
        proposal = product.proposal
        if proposal
          if product.proposal.quantity.to_i >= 0
            quantity = product.proposal.quantity
          else
            quantity = "0"
          end
        else
          quantity = "0"
        end
        price_type = PriceType.find_by(id_xml:PRICE_XML_ID_TO_SITE)
        if proposal and price_type
          begin
            price = Price.find_by(proposal_id: proposal.id, price_type_id: price_type.id).price
          rescue
            price = "0"
          end
        else
          price = "0"
        end

        #получаем категории товара

        product.groups.each do |group|
          group_id = find_group(group, result_categories, product) #знаходимо найближчу групу для товару
        end
        attribute_set = find_attribute_set(result_attribute_set, product)

        #якщо знайшли атрибут сет, шукаемо атрибути та записуемо їх значення
        if attribute_set != -1
          begin
            result_attribute = JSON.parse(RestClient.get "http://demo.beta.qpard.com/index.php/rest/V1/products/attribute-sets/#{attribute_set}/attributes",
                                                             {:Authorization => "Bearer #{@token_key.to_s.gsub('"','')}", :content_type => :json, :accept => :json})
          rescue => error
            puts_log_file("log_add_product_to_magento2", "ERROR: #{error}", "Фігня в гет запиті до атрибутів 'attribute-sets' ID: '#{attribute_set}' маженти")
          end

          attr_values = find_set_attribute(result_attribute, product)


          # begin
          #   req = RestClient.post "http://demo.beta.qpard.com/index.php/rest/V1/products",
          #                         {
          #                             "product":{
          #                                 "sku": "10090-White-XL#{i}",
          #                                 "name": "10090-White-XL#{i}",
          #                                 "attribute_set_id": 4,
          #                                 "price": 119,
          #                                 "status": 1,
          #                                 "visibility": 1,
          #                                 "type_id": "simple" }
          #                         }.to_json,
          #                         {
          #                             :Authorization => "Bearer #{result.to_s.gsub('"','')}",
          #                             :content_type => :json,
          #                             :accept => :json
          #                         }
          # rescue => error
          #   a=2
          # end
        else
          puts_log_file("log_add_product_to_magento2", "ERROR: ПРОДУКТ НЕ ЗБЕРЕЖЕНО'",
                        "Продукт '#{product.name}' ID: '#{product.id_xml}' не збережено через відсутність атрибут сету")
        end






      end





      render plain: "ok"

    end




  def find_group(group, result, product)
    category = []
    i = 0
    go = true

    category[i] = group.name
    parent_group = Group.find(group.groupable_id)
    while go do
      i +=1
      if parent_group.groupable_type == "Classifier"
        go = false
      else
        parent_group = Group.find(parent_group.groupable_id)
        category[i] = parent_group.name
      end
    end
    category.reverse!
    group_id = compare_category(result, category, 0, (category.count-1), product)

    return group_id
  end


  def compare_category(result, category, i, n, product)
    group_id = -1

    if result
      if result['name'] == ROOT_CATEGORY_MAGENTO
        group_id = result['id']
        group_id_result = compare_category(result['children_data'][0], category, 0, n, product)
        if group_id_result != -1
          group_id = group_id_result
        end

      else

        while i < n do
          if category[i] == result['name']
            if (i+1) == result['level']
              group_id = result['id']
            end
          end
          i += 1
          group_id_result = compare_category(result['children_data'][0], category, i, (n-1), product)
          if group_id_result == -1
            puts_log_file("log_add_product_to_magento2", "WARNING: Не знайдено групу!",
                          "Групу '#{category[i]}' для товару'#{product.name}' ID: '#{product.id_xml}' не знайдено у magento")
          else
            group_id = group_id_result
          end
        end
      end
    end
    return group_id
  end


  def find_attribute_set(result_attribute_set, product)
    attribute_set_id = -1
    i = 0
    requisite = Requisite.find_by(name: "ВидНоменклатуры")
    if requisite
      attr_set_1c = ProductRequisite.find_by(product_id: product.id, requisite_id: requisite.id)
      while i < result_attribute_set['total_count'] do
        if result_attribute_set['items'][i]['attribute_set_name'] == attr_set_1c.value
          attribute_set_id = result_attribute_set['items'][i]['attribute_set_id']
          i = result_attribute_set['total_count']
        end
        i +=1
      end
    end
    return attribute_set_id
  end

  def find_set_attribute(result_attribute, product)
    attribute_value = [{}]
    attribute_is_set = false
    product.properties.each do |propertie|
      unless attribute_is_set
        puts_log_file("log_add_product_to_magento2", "WARNING: Не знайдено групу!",
                      "Групу '#{category[i]}' для товару'#{product.name}' ID: '#{product.id_xml}' не знайдено у magento")
      end
      result_attribute.count.times do |i|
        if ATTRIBUTE_MAGENTO_1C.include?(result_attribute[i]['attribute_code'])
          product_propertie = ProductProperty.find_by(product_id: product.id, property_id: propertie.id)
          handbook = Handbook.find_by(id_xml: product_propertie.value)
          if handbook
            attribute_value[i] = {:attr_id => result_attribute[i]['attribute_id'], :attr_value => handbook.value}
            attribute_is_set = true
          end
        else

        end
      end
    end
    return attribute_value
  end

end


