module ExportCsvFromSite
  def export_customers(file)
    File.new(file, "w")

    # header = "ID;Name;Email;Group;Phone;ZIP;Country;State/Province;Customer Since;Web Site;Last Logged In;Confirmed email;Account Created in;Billing Address;Shipping Address;Date of Birth;Tax VAT Number;Gender;Street Address;City;Fax;VAT Number;Company;Billing Firstname;Billing Lastname;Action"
    header = "email;_website;_store;confirmation;created_at;created_in;disable_auto_group_change;
dob;firstname;gender;group_id;lastname;middlename;password_hash;prefix;reward_update_notification;
reward_warning_notification;rp_token;rp_token_created_at;store_id;suffix;taxvat;updated_at;website_id;password"

    # header = "id_csv;name;email;group;phone;zip;country;state;customer_since;web_site;last_logged_in;confirmed_email,
    #           account_created_in;billing_address;shipping_address;date_of_birth;tax_vat_number;gender,
    #           street_address;city;fax;vat_number;company;billing_firstname;billing_lastname;action"
    header = header.gsub("\n","").split(';')
    customers = Magento2Customer.all
    CSV.open( file, 'w') do |writer|
      writer << [header[0], header[1], header[2], header[3], header[4], header[5], header[6], header[7], header[8],
                 header[9], header[10], header[11], header[12], header[13], header[14], header[15], header[16], header[17],
                 header[18], header[19], header[20], header[21], header[22], header[23], header[24]]
      customers.each do |c|
        writer << [c.email, "http://asd.com", "", "", "", c.account_created_in, "", "", c.name, c.gender, c.group, "", "", "", "", "", "", "", "", "", "", c.tax_vat_number,
                   "", "", "123"]

            # c.name, c.email, c.group, "777-77-77", c.zip, c.country, c.state, c.customer_since, c.web_site, c.last_logged_in, c.confirmed_email, #c.phone
            #        c.account_created_in, c.billing_address, c.shipping_address, c.date_of_birth, c.tax_vat_number, c.gender,
            #        c.street_address, c.city, c.fax, c.vat_number, c.company, c.billing_firstname, c.billing_lastname, c.action]
      end
    end
  end



  def export_products(file)

    # products = Magento2CatalogProduct.all
    # CSV.open(file, 'w', :encoding => "UTF-8") do |writer|
    #    writer << [h[0], h[1], h[2], h[3], h[4], h[5], h[6], h[7], h[8], h[9], h[10], h[11], h[12], h[13], h[14], h[15],
    #               h[16], h[17], h[18], h[19], h[20], h[21], h[22], h[23], h[24], h[25], h[26], h[27], h[28], h[29],
    #               h[30], h[31], h[32], h[33], h[34], h[35], h[36], h[37], h[38], h[39], h[40], h[41], h[42], h[43],
    #               h[44], h[45], h[46], h[47], h[48], h[49], h[50], h[51], h[52], h[53], h[54], h[55], h[56], h[57],
    #               h[58], h[59], h[60], h[61], h[62], h[63], h[64], h[65], h[66], h[67], h[68], h[69], h[70], h[71],
    #               h[72], h[73], h[74], h[75], h[76], h[77], h[78], h[79], h[80]]
    #    products.each do |p|
    #     writer << [p.sku, p.store_view_code, p.attribute_set_code, p.product_type, p.categories, p.product_websites,
    #                p.name, p.description, p.short_description, p.weight, p.product_online, p.tax_class_name, p.visibility,
    #                p.price, p.special_price, p.special_price_from_date, p.special_price_to_date, p.url_key, p.meta_title,
    #                p.meta_keywords, p.meta_description, p.base_image, p.base_image_label, p.small_image, p.small_image_label,
    #                p.thumbnail_image, p.thumbnail_image_label, p.swatch_image, p.swatch_image_label, p.created_at,
    #                p.updated_at, p.new_from_date, p.new_to_date, p.display_product_options_in, p.map_price, p.msrp_price,
    #                p.map_enabled, p.gift_message_available, p.custom_design, p.custom_design_from, p.custom_design_to,
    #                p.custom_layout_update, p.page_layout, p.product_options_container, p.msrp_display_actual_price_type,
    #                p.country_of_manufacture, p.additional_attributes, p.qty, p.out_of_stock_qty, p.use_config_min_qty,
    #                p.is_qty_decimal, p.allow_backorders, p.use_config_backorders, p.min_cart_qty, p.use_config_min_sale_qty,
    #                p.max_cart_qty, p.use_config_max_sale_qty, p.is_in_stock, p.notify_on_stock_below, p.use_config_notify_stock_qty,
    #                p.manage_stock, p.use_config_manage_stock, p.use_config_qty_increments, p.qty_increments, p.use_config_enable_qty_inc,
    #                p.enable_qty_increments, p.is_decimal_divided, p.website_id, p.related_skus, p.crosssell_skus, p.upsell_skus,
    #                p.additional_images, p.additional_image_labels, p.hide_from_product_page, p.custom_options, p.bundle_price_type,
    #                p.bundle_sku_type, p.bundle_price_view, p.bundle_weight_type, p.bundle_values, p.associated_skus]
    #   end
    # end
    # go = true
    @category = []
    @price = []
    @quantity = []
    i = -1
    j = -1
    # commerce_information = CommerceInformation.find_by(name_document: "from_ERP_import", from_erp: true)
    # commerce_information.catalogs.each do |catalog|
    products = Product.where(in_out: "from_ERP").sort
      products.each do |p|

        j += 1
        proposal = p.proposal
        if proposal
          if p.proposal.quantity.to_i >= 0
            @quantity[j] = p.proposal.quantity
          else
            @quantity[j] = "0"
          end
        else
          @quantity[j] = "0"
        end

        price_type = PriceType.find_by(id_xml: PRICE_XML_ID_TO_SITE)
        if proposal and price_type
          begin
            @price[j] = Price.find_by(proposal_id: proposal.id, price_type_id: price_type.id).price
          rescue
            @price[j] = "0"
          end
        else
          @price[j] = "0"
        end




        #получаем категории товара
        i += 1
        go = true
        p.groups.each do |g|
          if @category[i].to_s != ""
            @category[i] = "," + "#{@category[i]}"
          end
          @category[i] = "#{g.name}"
          if g.groupable_type == "Group"
            parent_group = Group.find(g.groupable_id)
            @category[i] = "#{parent_group.name}" + "/" + "#{@category[i]}"
            while go do
              if parent_group.groupable_type == "Classifier"
                go = false
              else
                parent_group = Group.find(parent_group.groupable_id)
                @category[i] = "#{parent_group.name}" + "/" + "#{@category[i]}"
              end
            end
          end
        end
      end


    h = "sku; store_view_code; attribute_set_code; product_type; categories; product_websites; name; description; short_description; weight; product_online; tax_class_name;
 visibility; price; special_price; special_price_from_date; special_price_to_date; url_key; meta_title; meta_keywords; meta_description; base_image;
 base_image_label; small_image; small_image_label; thumbnail_image; thumbnail_image_label; swatch_image; swatch_image_label; created_at; updated_at;
 new_from_date; new_to_date; display_product_options_in; map_price; msrp_price; map_enabled; gift_message_available; custom_design; custom_design_from;
 custom_design_to; custom_layout_update; page_layout; product_options_container; msrp_display_actual_price_type; country_of_manufacture; additional_attributes; qty;
 out_of_stock_qty; use_config_min_qty; is_qty_decimal; allow_backorders; use_config_backorders; min_cart_qty; use_config_min_sale_qty; max_cart_qty;
 use_config_max_sale_qty; is_in_stock; notify_on_stock_below; use_config_notify_stock_qty; manage_stock; use_config_manage_stock; use_config_qty_increments;
 qty_increments; use_config_enable_qty_inc; enable_qty_increments; is_decimal_divided; website_id; related_skus; crosssell_skus; upsell_skus;
 additional_images; additional_image_labels; hide_from_product_page; custom_options; bundle_price_type; bundle_sku_type; bundle_price_view; bundle_weight_type;
 bundle_values; associated_skus"

    h = h.gsub("\n","").split('; ')
    @product_duplicate_url_key = []
    @n = -1
    i = -1
    next_product_duplicate_url_key = true

    CSV.open( file, 'w') do |writer|
      writer << [h[0], h[1], h[2], h[3], h[4], h[5], h[6], h[7], h[8], h[9], h[10], h[11], h[12], h[13], h[14], h[15],
                 h[16], h[17], h[18], h[19], h[20], h[21], h[22], h[23], h[24], h[25], h[26], h[27], h[28], h[29],
                 h[30], h[31], h[32], h[33], h[34], h[35], h[36], h[37], h[38], h[39], h[40], h[41], h[42], h[43],
                 h[44], h[45], h[46], h[47], h[48], h[49], h[50], h[51], h[52], h[53], h[54], h[55], h[56], h[57],
                 h[58], h[59], h[60], h[61], h[62], h[63], h[64], h[65], h[66], h[67], h[68], h[69], h[70], h[71],
                 h[72], h[73], h[74], h[75], h[76], h[77], h[78], h[79], h[80]]
      #проверить наличие нескольких каталогов в одной файле
      # commerce_information.catalogs.each do |catalog|
        products.each do |p|
          url_number = 0
          i += 1
          requisite = Requisite.find_by(name: 'Вес')
          if requisite
            product_weight = ProductRequisite.find_by(product_id: p.id, requisite_id: requisite.id)
            if product_weight
              product_weight = product_weight.value
            end
          end                                         #@category[i]
          if p.vendorcode == "0" or p.vendorcode == "" or p.vendorcode == nil
            sku = p.name
          else
            sku = p.vendorcode
          end

          #генерую унікальний url key для маженти
          name_product_count = Product.where(name: p.name)
          if name_product_count.count > 1
            @n += 1
            @product_duplicate_url_key.count.times do |number|
              if @product_duplicate_url_key[number][:name] == p.name
                url_number = @product_duplicate_url_key[number][:j] + 1
                @product_duplicate_url_key[number] = {:name => p.name, :j => url_number}
                next_product_duplicate_url_key = false
              end
            end
            url_key = p.name + "/#{url_number}"
            url_key
            if next_product_duplicate_url_key
              @product_duplicate_url_key[@n] = {:name => p.name, :j => url_number}
            else
              @n -= 1
              next_product_duplicate_url_key = true
            end
          else
            url_key = p.name
          end
          url_key = url_key.gsub(' ','-').gsub('"','').gsub("'",'').gsub('.','').mb_chars.downcase!

          requisite = Requisite.find_by(name: "ВидНоменклатуры")
          if requisite
            attr_set = ProductRequisite.find_by(product_id: p.id, requisite_id: requisite.id).value
          end

          product_attribute = find_attribute(p)


          writer << [sku, "", attr_set, "simple", @category[i], "base", p.name, p.description, "", product_weight, #10
                     "1", "Taxable Goods", "Catalog, Search", @price[i], "", "", "", url_key, "", "", "", "#{p.product_images.first.link_image}", "", "", "", "", "", "", "", "", #30
                     "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", product_attribute, @quantity[i], "", "", #50
                     "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", #70
                     "", "", "", "", "", "", "", "", "", "", ""] #81
        # end

      end
    end
  end


  def find_attribute_set(result_attribute_set, product)
    # attribute_set_id = -1
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




  def find_attribute(product)
    attribute_value = ""
    @not_find_in_constant = {:property_name => nil}
    product.properties.each do |property|

      @not_find_in_constant[:property_name] = property.name

      ATTRIBUTE_1C_MAGENTO.count.times do |j|
        if ATTRIBUTE_1C_MAGENTO[j][:in_1c].include?(property.name)
          @not_find_in_constant[:property_name] = nil
          if ATTRIBUTE_1C_MAGENTO[j][:in_magento] != ""
            product_propertie = ProductProperty.find_by(product_id: product.id, property_id: property.id)
             handbook = Handbook.find_by(id_xml: product_propertie.value)
             if handbook
               if attribute_value != ""
                 attribute_value += ",#{ATTRIBUTE_1C_MAGENTO[j][:in_magento]}=#{handbook.value}"
               else
                 attribute_value += "#{ATTRIBUTE_1C_MAGENTO[j][:in_magento]}=#{handbook.value}"
               end

            end
          end
          # result_attribute.count.times do |i|
          #   if ATTRIBUTE_1C_MAGENTO[j][:in_magento].include?(result_attribute[i]['attribute_code'])
          #     @not_find_in_magento[:attr_name] = nil
          #     product_propertie = ProductProperty.find_by(product_id: product.id, property_id: property.id)
          #     handbook = Handbook.find_by(id_xml: product_propertie.value)
          #     if handbook
          #       attribute_value << {
          #           :attr_id => result_attribute[i]['attribute_id'],
          #           :attr_name => result_attribute[i]['attribute_code'],
          #           :attr_value => handbook.value}
              # end
            #   break
            # end
          # end
          break
        end
      end
      if @not_find_in_constant[:property_name]
        puts_log_file("log_CSV_export_product_to_magento2", "WARNING: Не знайдено опис атрибуту!",
                      "Арибут '#{@not_find_in_constant[:property_name]}'  не знайдено у описі атрибутів ATTRIBUTE_1C_MAGENTO")
        @not_find_in_constant[:property_name] = nil
      end
    end
    return attribute_value
  end




end