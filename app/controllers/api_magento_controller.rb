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

      product_attribute_set_old = ""

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

        #отримуемо категорії товару

        сохранение группы товара

        product.groups.each do |group|
          group_id = find_group(group, result_categories, product) #знаходимо найближчу групу для товару
        end
        attribute_set = find_attribute_set(result_attribute_set, product)

        #якщо знайшли атрибут сет, шукаемо атрибути та записуемо їх значення
        if attribute_set[:name] != nil

          #(для прискорення) порівнюємо значення атрибут сету товару що вибирали раніше з поточним атрибут сетом товару
          if attribute_set[:name] != product_attribute_set_old
            begin
              @result_attribute = JSON.parse(RestClient.get "http://demo.beta.qpard.com/index.php/rest/V1/products/attribute-sets/#{attribute_set[:id]}/attributes",
                                                               {:Authorization => "Bearer #{@token_key.to_s.gsub('"','')}", :content_type => :json, :accept => :json})
            rescue => error
              puts_log_file("log_add_product_to_magento2", "ERROR: #{error}", "Фігня в гет запиті до атрибутів 'attribute-sets' ID: '#{attribute_set[:name]}' маженти")
            end
            product_attribute_set_old = attribute_set[:name]
          end
          attribute_value = find_attribute(@result_attribute, product)

          # begin
          #  req = RestClient.get "http://demo.beta.qpard.com/index.php/rest/V1/products?searchCriteria=''",
          #                  {:Authorization => "Bearer #{@token_key.to_s.gsub('"','')}", :content_type => :json, :accept => :json}
          #
          # rescue => error
          #   a=2
          # end


          begin
            req1 = RestClient.get "http://demo.beta.qpard.com/index.php/rest/V1/products/My%20Product",
                                 {:Authorization => "Bearer #{@token_key.to_s.gsub('"','')}", :content_type => :json, :accept => :json}

          rescue => error
            puts_log_file("log_add_product_to_magento2", "ERROR: #{error}", "")
          end
          a=2







          attribute_bloc = []
          attribute_value.count.times do |i|
            if (i + 1) == attribute_value.count
              ab = Hash.new
              ab[:attribute_code] = attribute_value[i][:attr_name].to_s
              ab[:value] = attribute_value[i][:attr_value].to_s
              attribute_bloc << ab
            end
          end

          begin
            RestClient.post "http://demo.beta.qpard.com/index.php/rest/V1/products",
                                  {
                                      "product": {
                                          "sku": product.id_xml,
                                          "name": product.name,
                                          "attribute_set_id": attribute_set[:id],
                                          "price": price,
                                          "status": 1,
                                          "visibility": 1,
                                          "type_id": "simple",
                                          "extension_attributes": {
                                              "stock_item": {
                                                  "qty": quantity
                                              }},
                                          "custom_attributes": attribute_bloc
                                      }
                                  }.to_json,
                                  {
                                      :Authorization => "Bearer #{@token_key.to_s.gsub('"','')}",
                                      :content_type => :json,
                                      :accept => :json
                                  }
          rescue => error
            puts_log_file("log_add_product_to_magento2", "ERROR: ПРОДУКТ НЕ ЗБЕРЕЖЕНО", "#{error} в POST запиті при зберіганні продукту '#{product.name}' ID: '#{product.id_xml}'")
          end
        else
          requisite = Requisite.find_by(name: "ВидНоменклатуры")
          if requisite
            attr_set_1c = ProductRequisite.find_by(product_id: product.id, requisite_id: requisite.id)
          end
          puts_log_file("log_add_product_to_magento2", "ERROR: ПРОДУКТ НЕ ЗБЕРЕЖЕНО",
                        "Продукт '#{product.name}' ID: '#{product.id_xml}' не збережено через відсутність атрибут сету '#{attr_set_1c.value}'")
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
                          "Групу '#{category[i]}' для товару '#{product.name}' ID: '#{product.id_xml}' не знайдено у magento")
          else
            group_id = group_id_result
          end
        end
      end
    end
    return group_id
  end


  def find_attribute_set(result_attribute_set, product)
    # attribute_set_id = -1
    attribute_set = {}
    i = 0
    requisite = Requisite.find_by(name: "ВидНоменклатуры")
    if requisite
      attr_set_1c = ProductRequisite.find_by(product_id: product.id, requisite_id: requisite.id)
      while i < result_attribute_set['total_count'] do
        if result_attribute_set['items'][i]['attribute_set_name'] == attr_set_1c.value
          attribute_set = {:id => result_attribute_set['items'][i]['attribute_set_id'],
                         :name => result_attribute_set['items'][i]['attribute_set_name']}
          i = result_attribute_set['total_count']
        end
        i +=1
      end
    end
    return attribute_set
  end

  def find_attribute(result_attribute, product)
    attribute_value = []
    n=0
    @not_find_in_constant = {:property_name => nil}
    @not_find_in_magento = {:attr_name => nil}
    product.properties.each do |property|

      @not_find_in_constant[:property_name] = property.name

      ATTRIBUTE_1C_MAGENTO.count.times do |j|
        if ATTRIBUTE_1C_MAGENTO[j][:in_1c].include?(property.name)
          @not_find_in_constant[:property_name] = nil
          @not_find_in_magento[:attr_name] = ATTRIBUTE_1C_MAGENTO[j][:in_1c]

          result_attribute.count.times do |i|
            if ATTRIBUTE_1C_MAGENTO[j][:in_magento].include?(result_attribute[i]['attribute_code'])
              @not_find_in_magento[:attr_name] = nil
              product_propertie = ProductProperty.find_by(product_id: product.id, property_id: property.id)
              handbook = Handbook.find_by(id_xml: product_propertie.value)
              if handbook
                attribute_value << {
                    :attr_id => result_attribute[i]['attribute_id'],
                    :attr_name => result_attribute[i]['attribute_code'],
                    :attr_value => handbook.value}
                # attribute_value[n] = {:attr_id => result_attribute[i]['attribute_id'], :attr_value => handbook.value}
                # n +=1
              end
              break
            else

            end
          end
          break
        end
      end
      if @not_find_in_constant[:property_name]
        puts_log_file("log_add_product_to_magento2", "WARNING: Не знайдено опис атрибуту!",
                      "Арибут '#{@not_find_in_constant[:property_name]}'  не знайдено у описі атрибутів ATTRIBUTE_1C_MAGENTO")
        @not_find_in_constant[:property_name] = nil
      elsif @not_find_in_magento[:attr_name]
        puts_log_file("log_add_product_to_magento2", "WARNING: Не знайдено атрибут!",
                      "Арибут 1C '#{@not_find_in_magento[:attr_name]}' не знайдено у списку атрибутів magento. Для товару '#{product.name}' ID: '#{product.id_xml}'")
        @not_find_in_magento[:attr_name] = nil
      end
    end
    return attribute_value
  end

end


