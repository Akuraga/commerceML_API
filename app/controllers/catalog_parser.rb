module CatalogParser

  def parse_catalog(catalog_doc, commerce_information)
    @new_catalog = Catalog.new
    @new_catalog.id_xml = catalog_doc.at_css('Ид').text
    @new_catalog.name = catalog_doc.at_css('Наименование').text
    @new_catalog.only_change = catalog_doc.css('Каталог')[0]['СодержитТолькоИзменения']
    if catalog_doc.at_css('ИдКлассификатора')
      classifier = Classifier.find_by(id_xml: catalog_doc.at_css('ИдКлассификатора').text)
      classifier.catalogs << @new_catalog
    end
    owner = Owner.find_by(id_xml: catalog_doc.at_css('Владелец Ид').text)
    unless owner
      owner = parse_owner(catalog_doc.at_css('Владелец'))
    end
    owner.catalogs << @new_catalog
    commerce_information.catalogs << @new_catalog
    parse_product(nil, catalog_doc.css('Товары'))
  end


  #Парсим товары

  def parse_product(document, product_doc)
    product_doc.css('Товар').each do |product|

      @new_product = Product.new
      if product.at_css('Ид')
        @new_product.id_xml     = product.at_css('Ид').text
      end
      if product.at_css('Артикул')
        @new_product.vendorcode = product.at_css('Артикул').text
      end
      if product.at_css('Штрихкод')
        @new_product.barcode    = product.at_css('Штрихкод').text
      end
      if product.at_css('Описание')
        @new_product.description    = product.at_css('Описание').text
      end
      if product.at_css('Картинка')
        product.css('Картинка').count.times do |i|
          new_image = ProductImage.new
          new_image.link_image = product.css('Картинка')[i].text
          @new_product.product_images << new_image
          new_image.save!
        end
      end
      @new_product.name         = product.at_css('Наименование').text
      @new_product.in_out       = "from_ERP"

      #парсим ед. изм
        unit = parse_unit(product.at_css('БазоваяЕдиница'))
        unit.products << @new_product

      if product.at_css('Группы')
        product.css('Группы Ид').each do |group|
          prod_group = Group.find_by(id_xml: group.text)
          if prod_group
            @new_product.groups << prod_group
          end
        end
      end
      if document.class != Document
        if @new_catalog
          @new_catalog.products << @new_product
        end
      end

      #парсим свойства товара
        if product.at_css('ЗначенияСвойств')
          parse_product_property(product.css('ЗначенияСвойств'), @new_product)
        end

      #парсим СтавкиНалогов товара
        if product.at_css('СтавкиНалогов')
          parse_taxes(product.css('СтавкиНалогов'), @new_product)
        end

      #парсим ХарактеристикиТовара товара
        if product.at_css('ХарактеристикиТовара')
          parse_attributes(product.css('ХарактеристикиТовара'), @new_product)
        end

      #парсим ЗначенияРеквизитов товара
        if product.at_css('ЗначенияРеквизитов')
          parse_requisite(product.css('ЗначенияРеквизитов'), @new_product)
        end

      if document.class == Document
        if product.at_css('Налоги')
          parse_order_tax(@new_product, product.css('Налоги'))
        end

        @new_document_product              = DocumentsProduct.new
        @new_document_product.price        = product.at_css('ЦенаЗаЕдиницу').text
        @new_document_product.quantity     = product.at_css('Количество').text
        @new_document_product.sum          = product.at_css('Сумма').text
        if product.at_css('Единица')
          @new_document_product.unit         = product.at_css('Единица').text
        end
        if product.at_css('Коэффициент')
          @new_document_product.coefficient  = product.at_css('Коэффициент').text
        end

        @new_document_product.product      = @new_product
        @new_document_product.document     = document
        @new_document_product.save!

        parse_discount(@new_product, product.css('Скидки'), document)

      end
    end
  end




  def parse_discount(object, discount_doc, document)
    discount_doc.css('Скидка').each do |discount|
      @new_discount          = Discount.new
      @new_discount.name     = discount.at_css('Наименование').text
      @new_discount.sum      = discount.at_css('Сумма').text
      @new_discount.percent  = discount.at_css('Процент').text
      @new_discount.in_total = discount.at_css('УчтеноВСумме').text

      object.discounts << @new_discount
      document.discounts << @new_discount
    end

  end



  #парсим ед.измерения

  def parse_unit(unit_doc)

    unit = Unit.find_by(code: unit_doc['Код'])
    if unit
      return unit
    else
      @new_unit = Unit.new
      @new_unit.name       = unit_doc.text
      @new_unit.code       = unit_doc['Код']
      @new_unit.full_name  = unit_doc['НаименованиеПолное']
      if unit_doc['МеждународноеСокращение']
        @new_unit.intern_cut = unit_doc['МеждународноеСокращение']
      end
      @new_unit.save!
      return @new_unit
    end
  end


  #парсим свойства товара

  def parse_product_property(property_doc, product)
    property_doc.css('ЗначенияСвойства').each do |property|
      prod_property = Property.find_by(id_xml: property.at_css('Ид').text)

      if prod_property
        new_product_property = ProductProperty.new
        new_product_property.product  = product
        new_product_property.property = prod_property
        if property.at_css('Значение')
          new_product_property.value  = property.css('Значение').text
        end
        new_product_property.save!
      end

      if property.at_css('Значение')
        property.css('Значение').count.times do |i|
          if property.css('Значение')[i].text != ""
            prod_handbook = Handbook.find_by(id_xml: property.css('Значение')[i].text)
            if prod_handbook
              @new_product.handbooks << prod_handbook
            end
          end
        end
      end
    end
  end


  #парсим СтавкиНалогов

  def parse_taxes(tax_doc, product)
    tax_doc.css('СтавкаНалога').each do |tax|
      product_tax = Tax.find_by(name: tax.at_css('Наименование').text)
      if product_tax
        insert_new_product_tax_value(tax.at_css('Ставка').text, product_tax, product)
      else
        @new_tax      = Tax.new
        @new_tax.name = tax.at_css('Наименование').text
        @new_tax.save!
        insert_new_product_tax_value(tax.at_css('Ставка').text, @new_tax, product)
      end
    end
    return @new_tax
  end

  def insert_new_product_tax_value(value, product_tax, product)
    product_tax_value = ProductTaxValue.find_by(tax_id: product_tax.id, product_id: product.id)
    if product_tax_value
      if product_tax_value.value != value
        product_tax_value.value = value
      end
      product_tax_value.save!
    else
      @new_product_tax_value         = ProductTaxValue.new
      @new_product_tax_value.product = product
      @new_product_tax_value.tax     = product_tax
      @new_product_tax_value.value   = value
      @new_product_tax_value.save!
    end

  end


  #парсим характеристики товара

  def parse_attributes(attributes_doc, product)
    attributes_doc.css('ХарактеристикаТовара').each do |attribute|
      product_attribute = ProductAttribute.find_by(name: attribute.at_css('Наименование').text)
      if product_attribute
        insert_new_product_attribute_value(attribute.at_css('Значение').text, product_attribute, product)
      else
        @new_product_attribute      = ProductAttribute.new
        @new_product_attribute.name = attribute.at_css('Наименование').text
        @new_product_attribute.save!
        insert_new_product_attribute_value(attribute.at_css('Значение').text, @new_product_attribute, product)
      end
    end
  end

  def insert_new_product_attribute_value(value, product_attribute, product)
    product_attribute_value = ProductAttributeValue.find_by(product_attribute_id: product_attribute.id, product_id: product.id)
    if product_attribute_value
      if product_attribute_value.value != value
        product_attribute_value.value = value
      end
      product_attribute_value.save!
    else
      @new_product_attribute_value                   = ProductAttributeValue.new
      @new_product_attribute_value.product_attribute = product_attribute
      @new_product_attribute_value.product           = product
      @new_product_attribute_value.value             = value
      @new_product_attribute_value.save!
    end

  end






  #парсим реквизиты товара

  def parse_requisite(requisite_doc, product)
    requisite_doc.css('ЗначениеРеквизита').each do |requisite|
      product_requisite = Requisite.find_by(name: requisite.at_css('Наименование').text)
      if product_requisite
        insert_new_product_requisite_value(requisite.at_css('Значение').text, product_requisite, product)
      else
        @new_requisite = Requisite.new
        @new_requisite.name = requisite.at_css('Наименование').text
        @new_requisite.save!
        insert_new_product_requisite_value(requisite.at_css('Значение').text, @new_requisite, product)
      end
    end
  end

  def insert_new_product_requisite_value(value, product_requisite, product)
    product_requisite_value = ProductRequisite.find_by(requisite_id: product_requisite.id, product_id: product.id)
    if product_requisite_value
      if product_requisite_value.value != value
        product_requisite_value.value = value
      end
      product_requisite_value.save!
    else
      @new_product_requisite_value           = ProductRequisite.new
      @new_product_requisite_value.product   = product
      @new_product_requisite_value.requisite = product_requisite
      @new_product_requisite_value.value = value
      @new_product_requisite_value.save!
    end

  end



  def parse_order_tax(product , order_tax_doc)
    order_tax_doc.css('Налог').each do |order_tax|
      product_tax = Tax.find_by(name: order_tax.at_css('Наименование').text)
      if product_tax
        insert_new_order_tax_value(product, order_tax, product_tax)
      else
        @new_tax      = Tax.new
        @new_tax.name = order_tax.at_css('Наименование').text
        @new_tax.save!
        insert_new_order_tax_value(product, order_tax, @new_tax)
      end
    end
  end

  def insert_new_order_tax_value(product, value, tax)
    order_tax_value = OrderTaxValue.find_by(tax_id: tax.id, product_id: product.id)
    if order_tax_value
      if order_tax_value.in_total != value.at_css('УчтеноВСумме').text
        order_tax_value.in_total = value.at_css('УчтеноВСумме').text
      end
      if order_tax_value.sum != value.at_css('Сумма').text
        order_tax_value.sum = value.at_css('Сумма').text
      end
        if order_tax_value.rate != value.at_css('Ставка').text
          order_tax_value.rate = value.at_css('Ставка').text
        end
      order_tax_value.save!
    else
      @new_order_tax_value          = OrderTaxValue.new
      @new_order_tax_value.product  = product
      @new_order_tax_value.tax      = tax

      @new_order_tax_value.in_total = value.at_css('УчтеноВСумме').text
      @new_order_tax_value.sum      = value.at_css('Сумма').text
      @new_order_tax_value.rate     = value.at_css('Ставка').text
      @new_order_tax_value.save!
    end

  end


end

