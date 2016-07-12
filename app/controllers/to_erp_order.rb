module ToErpOrder


  def create_order_to_erp
    commerce_info = CommerceInformation.find_by(name_document: "from_ERP_order")#, to_erp: false) #заменить на "from_site_order" когда будем рельно парсить информацию с сайта

    @doc = Nokogiri::XML('to.xml')

    node_commerce_inf = Nokogiri::XML::Node.new('КоммерческаяИнформация', @doc)
    node_commerce_inf['ВерсияСхемы'] = commerce_info.version
    node_commerce_inf['ДатаФормирования'] = commerce_info.date
    @doc.root = node_commerce_inf

    commerce_info.documents.each do |document|

      node_document = Nokogiri::XML::Node.new('Документ', @doc)
      node_commerce_inf.add_child node_document

      node_id = Nokogiri::XML::Node.new('Ид', @doc)
      node_id.content = document.id_xml
      node_document.add_child node_id

      node_number = Nokogiri::XML::Node.new('Номер', @doc)
      node_number.content = document.number
      node_document.add_child node_number

      node_date = Nokogiri::XML::Node.new('Дата', @doc)
      node_date.content = document.date
      node_document.add_child node_date

      node_economic_op = Nokogiri::XML::Node.new('ХозОперация', @doc)
      node_economic_op.content = document.economic_op
      node_document.add_child node_economic_op

      node_role = Nokogiri::XML::Node.new('Роль', @doc)
      node_role.content = document.role
      node_document.add_child node_role

      node_currency = Nokogiri::XML::Node.new('Валюта', @doc)
      node_currency.content = document.currency
      node_document.add_child node_currency

      node_course = Nokogiri::XML::Node.new('Курс', @doc)
      node_course.content = document.course
      node_document.add_child node_course

      node_sum = Nokogiri::XML::Node.new('Сумма', @doc)
      node_sum.content = document.sum
      node_document.add_child node_sum

      node_contractors = Nokogiri::XML::Node.new('Контрагенты', @doc)
      node_document.add_child node_contractors

      add_contractors(document.contractors, node_contractors)

      node_time = Nokogiri::XML::Node.new('Время', @doc)
      node_time.content = document.time
      node_document.add_child node_time

      if document.payment_term
        node_payment_term = Nokogiri::XML::Node.new('СрокПлатежа', @doc)
        node_payment_term.content = document.payment_term
        node_document.add_child node_payment_term
      end

      node_comment = Nokogiri::XML::Node.new('Комментарий', @doc)
      node_comment.content = document.comment
      node_document.add_child node_comment


      #налоги для документа
      node_taxes = Nokogiri::XML::Node.new('Налоги', @doc)
      node_document.add_child node_taxes

        document.taxes.each do |tax|
          node_tax = Nokogiri::XML::Node.new('Налог', @doc)
          node_taxes.add_child node_tax

          node_name = Nokogiri::XML::Node.new('Наименование', @doc)
          node_name.content = tax.name
          node_tax.add_child node_name

          document_tax_value = DocumentsTaxValue.find_by(tax_id: tax.id, document_id: document.id)

          node_in_total = Nokogiri::XML::Node.new('УчтеноВСумме', @doc)
          node_in_total.content = document_tax_value.in_total
          node_tax.add_child node_in_total

          node_sum = Nokogiri::XML::Node.new('Сумма', @doc)
          node_sum.content = document_tax_value.sum
          node_tax.add_child node_sum
      end


      node_products = Nokogiri::XML::Node.new('Товары', @doc)
      node_document.add_child node_products

      add_products(document.products, node_products, document)

      if document.requisites.count > 0
        add_requisites(document.requisites, node_document, document)
      end
    end
    commerce_info.to_erp = true
    commerce_info.save!
    return @doc
  end



  #добавляем значения реквизитов для товара

  def add_requisites(requisites_doc, master_node, document)
    node_requisites = Nokogiri::XML::Node.new('ЗначенияРеквизитов', @doc)
    master_node.add_child node_requisites

    requisites_doc.each do |requisite|

      node_requisite = Nokogiri::XML::Node.new('ЗначениеРеквизита', @doc)
      node_requisites.add_child node_requisite

      requisite_value = DocumentRequisite.find_by(document_id: document.id, requisite_id: requisite.id)

      node_name = Nokogiri::XML::Node.new('Наименование', @doc)
      node_name.content = requisite.name
      node_requisite.add_child node_name

      node_value = Nokogiri::XML::Node.new('Значение', @doc)
      node_value.content = requisite_value.value
      node_requisite.add_child node_value
    end

  end



  #добавляем товар

  def add_products(product_doc, master_node, document)
    product_doc.each do |product|
      node_product = Nokogiri::XML::Node.new('Товар', @doc)
      master_node.add_child node_product

      if product.id_xml
        node_id = Nokogiri::XML::Node.new('Ид', @doc)
        node_id.content = product.id_xml
        node_product.add_child node_id
      end

      if product.catalog
        node_id_catalog = Nokogiri::XML::Node.new('ИдКаталога', @doc)
        node_id_catalog.content = product.catalog.id_xlm
        node_product.add_child node_id_catalog
      end

      if product.barcode
        node_barcode = Nokogiri::XML::Node.new('Штрихкод', @doc)
        node_barcode.content = product.barcode
        node_product.add_child node_barcode
      end

      if product.vendorcode
        node_vendorcode = Nokogiri::XML::Node.new('Артикул', @doc)
        node_vendorcode.content = product.vendorcode
        node_product.add_child node_vendorcode
      end

      node_name = Nokogiri::XML::Node.new('Наименование', @doc)
      node_name.content = product.name
      node_product.add_child node_name

      node_unit = Nokogiri::XML::Node.new('БазоваяЕдиница', @doc)
      node_unit['Код'] = product.unit.code
      node_unit['НаименованиеПолное'] = product.unit.full_name
      node_unit['МеждународноеСокращение'] = product.unit.intern_cut
      node_unit.content = product.unit.name
      node_product.add_child node_unit


      #ставки налгов для товара
        node_taxes_rates = Nokogiri::XML::Node.new('СтавкиНалогов', @doc)
        node_product.add_child node_taxes_rates

        product.taxes.each do |tax|
          node_tax_rate = Nokogiri::XML::Node.new('СтавкаНалога', @doc)
          node_taxes_rates.add_child node_tax_rate

          node_name = Nokogiri::XML::Node.new('Наименование', @doc)
          node_name.content = tax.name
          node_tax_rate.add_child node_name

          product_tax_value = ProductTaxValue.find_by(product_id: product.id, tax_id: tax.id)

          node_rate = Nokogiri::XML::Node.new('Ставка', @doc)
          node_rate.content = product_tax_value.value
          node_tax_rate.add_child node_rate
        end

      #ХарактеристикиТовара
        if product.product_attributes.count > 0
          node_product_attributes = Nokogiri::XML::Node.new('ХарактеристикиТовара', @doc)
          node_product.add_child node_product_attributes

          product.product_attributes.each do |attribute|
            node_product_attribute = Nokogiri::XML::Node.new('ХарактеристикаТовара', @doc)
            node_product_attributes.add_child node_product_attribute

            node_name = Nokogiri::XML::Node.new('Наименование', @doc)
            node_name.content = attribute.name
            node_product_attribute.add_child node_name

            product_attribute_value = ProductAttributeValue.find_by(product_id: product.id, product_attribute_id: attribute.id)

            node_value = Nokogiri::XML::Node.new('Значение', @doc)
            node_value.content = product_attribute_value.value
            node_product_attribute.add_child node_value
          end
        end




      #Значения реквизитов для товара
        node_requisites = Nokogiri::XML::Node.new('ЗначенияРеквизитов', @doc)
        node_product.add_child node_requisites

        node_requisite = Nokogiri::XML::Node.new('ЗначениеРеквизита', @doc)
        node_requisites.add_child node_requisite

        requisite = Requisite.find_by(name: "ВидНоменклатуры")
        requisite_value = ProductRequisite.find_by(product_id: product.id, requisite_id: requisite.id)

        node_name = Nokogiri::XML::Node.new('Наименование', @doc)
        node_name.content = "ВидНоменклатуры"
        node_requisite.add_child node_name

        node_value = Nokogiri::XML::Node.new('Значение', @doc)
        node_value.content = requisite_value.value
        node_requisite.add_child node_value

        node_requisite = Nokogiri::XML::Node.new('ЗначениеРеквизита', @doc)
        node_requisites.add_child node_requisite

        requisite = Requisite.find_by(name: "ТипНоменклатуры")
        requisite_value = ProductRequisite.find_by(product_id: product.id, requisite_id: requisite.id)

        node_name = Nokogiri::XML::Node.new('Наименование', @doc)
        node_name.content = "ТипНоменклатуры"
        node_requisite.add_child node_name

        node_value = Nokogiri::XML::Node.new('Значение', @doc)
        node_value.content = requisite_value.value
        node_requisite.add_child node_value


      documents_product = DocumentsProduct.find_by(document_id: document.id, product_id: product.id)

      node_price = Nokogiri::XML::Node.new('ЦенаЗаЕдиницу', @doc)
      node_price.content = documents_product.price
      node_product.add_child node_price

      node_quantity = Nokogiri::XML::Node.new('Количество', @doc)
      node_quantity.content = documents_product.quantity
      node_product.add_child node_quantity

      node_sum = Nokogiri::XML::Node.new('Сумма', @doc)
      node_sum.content = documents_product.sum
      node_product.add_child node_sum

      if documents_product.unit
        node_unit = Nokogiri::XML::Node.new('Единица', @doc)
        node_unit.content = documents_product.unit
        node_product.add_child node_unit
      end

      node_coefficient = Nokogiri::XML::Node.new('Коэффициент', @doc)
      node_coefficient.content = documents_product.coefficient
      node_product.add_child node_coefficient


      #налоги для товара
        node_taxes = Nokogiri::XML::Node.new('Налоги', @doc)
        node_product.add_child node_taxes

        product.taxes.each do |tax|
          node_tax = Nokogiri::XML::Node.new('Налог', @doc)
          node_taxes.add_child node_tax

          node_name = Nokogiri::XML::Node.new('Наименование', @doc)
          node_name.content = tax.name
          node_tax.add_child node_name

          order_tax_value = OrderTaxValue.find_by(tax_id: tax.id, product_id: product.id)

          node_in_total = Nokogiri::XML::Node.new('УчтеноВСумме', @doc)
          node_in_total.content = order_tax_value.in_total
          node_tax.add_child node_in_total

          node_sum = Nokogiri::XML::Node.new('Сумма', @doc)
          node_sum.content = order_tax_value.sum
          node_tax.add_child node_sum

          node_rate = Nokogiri::XML::Node.new('Ставка', @doc)
          node_rate.content = order_tax_value.rate
          node_tax.add_child node_rate
        end

      #Скидки для товара
        if product.discounts.count > 0

          node_discounts = Nokogiri::XML::Node.new('Скидки', @doc)
          node_product.add_child node_discounts

          product.discounts.each do |discount|
            if document.id == discount.document_id
              node_discount = Nokogiri::XML::Node.new('Скидка', @doc)
              node_discounts.add_child node_discount

              node_name = Nokogiri::XML::Node.new('Наименование', @doc)
              node_name.content = discount.name
              node_discount.add_child node_name

              node_sum = Nokogiri::XML::Node.new('Сумма', @doc)
              node_sum.content = discount.name
              node_discount.add_child node_sum

              node_percent = Nokogiri::XML::Node.new('Процент', @doc)
              node_percent.content = discount.percent
              node_discount.add_child node_percent

              node_in_total = Nokogiri::XML::Node.new('УчтеноВСумме', @doc)
              node_in_total.content = discount.in_total
              node_discount.add_child node_in_total

            else
              node_discounts.remove
            end
          end
        end
    end
  end


  #добавляем контрагентова для документа

  def add_contractors(contractors, master_node)
    contractors.each do |contractor|
      node_contractor = Nokogiri::XML::Node.new('Контрагент', @doc)
      master_node.add_child node_contractor

      node_id = Nokogiri::XML::Node.new('Ид', @doc)
      node_id.content = contractor.id_xml
      node_contractor.add_child node_id

      node_name = Nokogiri::XML::Node.new('Наименование', @doc)
      node_name.content = contractor.name
      node_contractor.add_child node_name

      if contractor.personable_type == "LegalEntity"
        add_legal_entity(contractor.personable_id, node_contractor)
      else
        add_physical_persone(contractor.personable_id, node_contractor)
      end

      node_role = Nokogiri::XML::Node.new('Роль', @doc)
      node_role.content = contractor.role
      node_contractor.add_child node_role

      if contractor.representatives.count > 0
        add_representative(contractor.representatives, node_contractor)
      end

      if contractor.contacts.count > 0
        add_contact(contractor.contacts, node_contractor)
      end

    end
  end




  def add_contact(contact_doc, master_node)
    node_contacts = Nokogiri::XML::Node.new('Контакты', @doc)
    master_node.add_child node_contacts


    contact_doc.each do |contact|
      node_contact = Nokogiri::XML::Node.new('Контакт', @doc)
      node_contacts.add_child node_contact

      node_contact_type = Nokogiri::XML::Node.new('Тип', @doc)
      node_contact_type.content = contact.contact_type
      node_contact.add_child node_contact_type

      node_value = Nokogiri::XML::Node.new('Значение', @doc)
      node_value.content = contact.value
      node_contact.add_child node_value

      node_comment = Nokogiri::XML::Node.new('Комментарий', @doc)
      node_comment.content = contact.comment
      node_contact.add_child node_comment

    end
  end

  #Пердставители

  def add_representative(representative_doc, master_node)
    node_representatives = Nokogiri::XML::Node.new('Представители', @doc)
    master_node.add_child node_representatives

    representative_doc.each do |representative|
      node_representative = Nokogiri::XML::Node.new('Представитель', @doc)
      node_representatives.add_child node_representative

      node_contractor = Nokogiri::XML::Node.new('Контрагент', @doc)
      node_representative.add_child node_contractor

      node_relation = Nokogiri::XML::Node.new('Отношение', @doc)
      node_relation.content = representative.relation
      node_contractor.add_child node_relation

      node_id_xml = Nokogiri::XML::Node.new('Ид', @doc)
      node_id_xml.content = representative.id_xml
      node_contractor.add_child node_id_xml

      node_name = Nokogiri::XML::Node.new('Наименование', @doc)
      node_name.content = representative.name
      node_contractor.add_child node_name

      if representative.address
        node_representative_address = Nokogiri::XML::Node.new('Адрес', @doc)
        node_contractor.add_child node_representative_address

        node_address = Nokogiri::XML::Node.new('Представление', @doc)
        node_address.content = representative.address
        node_representative_address.add_child node_address

        add_address_fields(representative, node_representative_address, @doc)
      end

      if representative.contacts
        add_contact(representative.contacts, node_contractor)
      end

    end
  end




  #добавляем реквизити юр. лица если покупатель юр. лицо

  def add_legal_entity(legal_entity, master_node)
    legal_entity = LegalEntity.find(legal_entity)

    node_official_name = Nokogiri::XML::Node.new('ОфициальноеНаименование', @doc)
    node_official_name.content = legal_entity.official_name
    master_node.add_child node_official_name

    if legal_entity.inn
      node_inn = Nokogiri::XML::Node.new('ИНН', @doc)
      node_inn.content = legal_entity.inn
      master_node.add_child node_inn
    end

    if legal_entity.kpp
      node_kpp = Nokogiri::XML::Node.new('КПП', @doc)
      node_kpp.content = legal_entity.kpp
      master_node.add_child node_kpp
    end

    if legal_entity.egrpo
      node_egrpo = Nokogiri::XML::Node.new('ЕГРПО', @doc)
      node_egrpo.content = legal_entity.egrpo
      master_node.add_child node_egrpo
    end

    if legal_entity.okpo
      node_okpo = Nokogiri::XML::Node.new('ОКПО', @doc)
      node_okpo.content = legal_entity.okpo
      master_node.add_child node_okpo
    end

    if legal_entity.address
      node_legal_address = Nokogiri::XML::Node.new('ЮридическийАдрес', @doc)
      master_node.add_child node_legal_address

      node_address = Nokogiri::XML::Node.new('Представление', @doc)
      node_address.content = legal_entity.address
      node_legal_address.add_child node_address

      add_address_fields(legal_entity, node_legal_address, @doc)
    end
  end


    #добавляем физических лиц

  def add_physical_persone(physical_persone, master_node)
    physical_persone = PhysicalPersone.find(physical_persone)

    node_full_name = Nokogiri::XML::Node.new('ПолноеНаименование', @doc)
    node_full_name.content = physical_persone.full_name
    master_node.add_child node_full_name

    if physical_persone.appeal
      node_appeal = Nokogiri::XML::Node.new('Обращение', @doc)
      node_appeal.content = physical_persone.appeal
      master_node.add_child node_appeal
    end

    if physical_persone.last_name
      node_last_name = Nokogiri::XML::Node.new('Фамилия', @doc)
      node_last_name.content = physical_persone.last_name
      master_node.add_child node_last_name
    end

    if physical_persone.first_name
      node_first_name = Nokogiri::XML::Node.new('Имя', @doc)
      node_first_name.content = physical_persone.first_name
      master_node.add_child node_first_name
    end

    if physical_persone.patronymic
      node_patronymic = Nokogiri::XML::Node.new('Отчество', @doc)
      node_patronymic.content = physical_persone.patronymic
      master_node.add_child node_patronymic
    end

    if physical_persone.date_birth
      node_date_birth = Nokogiri::XML::Node.new('ДатаРождения', @doc)
      node_date_birth.content = physical_persone.date_birth
      master_node.add_child node_date_birth
    end

    if physical_persone.inn
      node_inn = Nokogiri::XML::Node.new('ИНН', @doc)
      node_inn.content = physical_persone.inn
      master_node.add_child node_inn
    end

    if physical_persone.kpp
      node_kpp = Nokogiri::XML::Node.new('ДатаРождения', @doc)
      node_kpp.content = physical_persone.kpp
      master_node.add_child node_kpp
    end

    if physical_persone.identity_card_id
      node_identity_card = Nokogiri::XML::Node.new('УдостоверениеЛичности', @doc)
      master_node.add_child node_identity_card

      add_identity_card(physical_persone, node_identity_card)
    end


    if physical_persone.address
      node_physical_address = Nokogiri::XML::Node.new('АдресРегистрации', @doc)
      master_node.add_child node_physical_address

      node_address = Nokogiri::XML::Node.new('Представление', @doc)
      node_address.content = physical_persone.address
      node_physical_address.add_child node_address

      add_address_fields(physical_persone, node_physical_address, @doc)
    end
  end


  #Идентификационная карта

  def add_identity_card(physical_persone, master_node)
    if physical_persone.identity_card.type_document
      node_type_document = Nokogiri::XML::Node.new('ВидДокумента', @doc)
      node_type_document.content = physical_persone.identity_card.type_document
      master_node.add_child node_type_document
    end

    if physical_persone.identity_card.series
      node_series = Nokogiri::XML::Node.new('Серия', @doc)
      node_series.content = physical_persone.identity_card.series
      master_node.add_child node_series
    end

    if physical_persone.identity_card.number
      node_number = Nokogiri::XML::Node.new('Номер', @doc)
      node_number.content = physical_persone.identity_card.number
      master_node.add_child node_number
    end

    if physical_persone.identity_card.issue_date
      node_issue_date = Nokogiri::XML::Node.new('ДатаВыдачи', @doc)
      node_issue_date.content = physical_persone.identity_card.issue_date
      master_node.add_child node_issue_date
    end

    if physical_persone.identity_card.issued_by
      node_issued_by = Nokogiri::XML::Node.new('КемВыдан', @doc)
      node_issued_by.content = physical_persone.identity_card.issued_by
      master_node.add_child node_issued_by
    end
  end



   # def to_my_xml(options = {})
   #   require 'builder'
   #   options[:indent] ||= 2
   #   xml = options[:builder] ||= ::Builder::XmlMarkup.new(indent: options[:indent])
   #   xml.instruct! :xml, :version=>"1.0", :encoding => "UTF-8"
   #   xml.level_one do
   #     xml.tag!(:second_level, 'content')
   #   end
   # end

end