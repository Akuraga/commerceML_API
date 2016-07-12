module OrderParser
  def parse_order(order, commerce_information)
    order.css('Документ').each do |order|

      @new_document              = Document.new
      @new_document.id_xml       = order.at_css('Ид').text
      @new_document.number       = order.at_css('Номер').text
      @new_document.date         = order.at_css('Дата').text
      @new_document.economic_op  = order.at_css('ХозОперация').text
      @new_document.role         = order.at_css('Роль').text
      @new_document.currency     = order.at_css('Валюта').text
      @new_document.course       = order.at_css('Курс').text
      @new_document.sum          = order.at_css('Сумма').text
      @new_document.time         = order.at_css('Время').text
      if order.at_css('СрокПлатежа')
        @new_document.payment_term = order.at_css('СрокПлатежа').text
      end
      @new_document.comment      = order.at_css('Комментарий').text

      commerce_information.documents << @new_document
      @new_document.save!

      if order.at_css('ЗначенияРеквизитов')
        Nokogiri::XML::SAX::Parser.new(ParserDocument.new).parse(order.to_xml)
        #parse_document_requisite(order.css('ЗначенияРеквизитов'))
      end


      if order.at_css('Контрагенты')
        parse_contractor(order.css('Контрагенты'))
      end
      if order.at_css('Налоги')
        parse_document_tax(@new_document, order.at_css('Налоги'))
      end
      if order.at_css('Товары')
        parse_product(@new_document, order.css('Товары'))
      end




    end
  end


  def parse_contractor(contractors_doc)
    contractors_doc.css('Контрагент').each do |contractor|
      @new_contractor         = Contractor.new
      @new_contractor.id_xml  = contractor.at_css('Ид').text
      @new_contractor.name  = contractor.at_css('Наименование').text
      @new_contractor.role    = contractor.at_css('Роль').text
      @new_contractor.save!
      @new_document.contractors << @new_contractor
      if contractor.at_css('ПолноеНаименование')
        physical_person = parse_physical_person(contractor)
        physical_person.contractors << @new_contractor
      elsif contractor.at_css('ОфициальноеНаименование')
        legel = parse_legan_entitie(contractor)
        legel.contractors << @new_contractor
      end

      if contractor.at_css('Контакты')
        parse_contact(@new_contractor,contractor.css('Контакты'))
      end
      if contractor.at_css('Представители')
        parse_representative(contractor.css('Представители'))
      end

    end
  end


  #парсим физ лицо

  def parse_physical_person(physical_person_doc)
    @new_physical_person = PhysicalPersone.new
    @new_physical_person.full_name = physical_person_doc.at_css('ПолноеНаименование').text
    if physical_person_doc.at_css('Обращение')
      @new_physical_person.appeal = physical_person_doc.at_css('Обращение').text
    end
    if physical_person_doc.at_css('Фамилия')
      @new_physical_person.last_name = physical_person_doc.at_css('Фамилия').text
    end
    if physical_person_doc.at_css('Имя')
      @new_physical_person.first_name = physical_person_doc.at_css('Имя').text
    end
    if physical_person_doc.at_css('Отчество')
      @new_physical_person.patronymic = physical_person_doc.at_css('Отчество').text
    end
    if physical_person_doc.at_css('ДатаРождения')
      @new_physical_person.date_birth = physical_person_doc.at_css('ДатаРождения').text
    end
    if physical_person_doc.at_css('ИНН')
      @new_physical_person.inn = physical_person_doc.at_css('ИНН').text
    end
    if physical_person_doc.at_css('КПП')
      @new_physical_person.kpp = physical_person_doc.at_css('КПП').text
    end
    if physical_person_doc.at_css('АдресРегистрации')
      parse_address(@new_physical_person, physical_person_doc.css('АдресРегистрации'))
    end
    @new_physical_person.save!
    if physical_person_doc.at_css('УдостоверениеЛичности')
       parse_identity_card(physical_person_doc.css('УдостоверениеЛичности'))
    end
    return @new_physical_person
  end


  #парсим ид. карту у физ лица (если есть)

  def parse_identity_card(identity_card_doc)
    @new_identity_card = IdentityCard.new
    if identity_card_doc.at_css('ВидДокумента')
      @new_identity_card.type_document = identity_card_doc.at_css('ВидДокумента').text
    end
    if identity_card_doc.at_css('ВидДокумента')
      @new_identity_card.type_document = identity_card_doc.at_css('ВидДокумента').text
    end
    if identity_card_doc.at_css('Серия')
      @new_identity_card.series = identity_card_doc.at_css('Серия').text
    end
    if identity_card_doc.at_css('Номер')
      @new_identity_card.number = identity_card_doc.at_css('Номер').text
    end
    if identity_card_doc.at_css('ДатаВыдачи')
      @new_identity_card.issue_date = identity_card_doc.at_css('ДатаВыдачи').text
    end
    if identity_card_doc.at_css('КемВыдан')
      @new_identity_card.issued_by = identity_card_doc.at_css('КемВыдан').text
    end
    @new_physical_person.identity_card << @new_identity_card
  end


  #парсим юридических лиц

  def parse_legan_entitie(legan_entitie_doc)
    @new_legan_entitie = LegalEntity.new
    @new_legan_entitie.official_name = legan_entitie_doc.at_css('ОфициальноеНаименование').text
    if legan_entitie_doc.at_css('ИНН')
      @new_legan_entitie.inn = legan_entitie_doc.at_css('ИНН').text
    end
    if legan_entitie_doc.at_css('КПП')
      @new_legan_entitie.kpp = legan_entitie_doc.at_css('КПП').text
    end
    if legan_entitie_doc.at_css('ЕГРПО')
      @new_legan_entitie.egrpo = legan_entitie_doc.at_css('ЕГРПО').text
    end
    if legan_entitie_doc.at_css('ОКПО')
      @new_legan_entitie.okpo = legan_entitie_doc.at_css('ОКПО').text
    end
    if legan_entitie_doc.at_css('ЮридическийАдрес')
      parse_address(@new_legan_entitie, legan_entitie_doc.css('ЮридическийАдрес'))
    end
    @new_legan_entitie.save!
    return @new_legan_entitie
  end


  #парсим контакты

  def parse_contact(object, contact_doc)
    if contact_doc.at_css('Контакт')
      contact_doc.css('Контакт').each do |contact|
        @new_contact              = Contact.new
        @new_contact.contact_type = contact.at_css('Тип').text
        @new_contact.value        = contact.at_css('Значение').text
        @new_contact.comment      = contact.at_css('Комментарий').text
        object.contacts << @new_contact
      end
    end
  end


  #парсим представителей

  def parse_representative(representative_doc)
    representative_doc.css('Представитель').each do |representative|
      @new_representative = Representative.new
      @new_representative.id_xml = representative.at_css('Ид').text
      @new_representative.name = representative.at_css('Наименование').text
      @new_representative.relation = representative.at_css('Отношение').text
      if representative.at_css('ЮридическийАдрес')
        parse_address(@new_representative, representative.css('ЮридическийАдрес'))
      end
      if representative.at_css('АдресРегистрации')
        parse_address(@new_representative, representative.css('АдресРегистрации'))
      end
      if representative.at_css('Контакты')
        parse_contact(@new_representative,representative.css('Контакты'))
      end
      @new_contractor.representatives << @new_representative
    end
  end


  #парсим налоги у документа

  def parse_document_tax(object, document_tax_doc)
    if document_tax_doc.at_css('Налог')
      document_tax_doc.css('Налог').each do |document_tax|
        tax = Tax.find_by(name: document_tax.at_css('Наименование').text)
        if tax
          @new_document_tax_value = DocumentsTaxValue.new
          @new_document_tax_value.in_total = document_tax.at_css('УчтеноВСумме').text
          @new_document_tax_value.sum = document_tax.at_css('Сумма').text
        else
          tax = Tax.new
          tax.name = document_tax.at_css('Наименование').text
          tax.save!
          @new_document_tax_value = DocumentsTaxValue.new
          @new_document_tax_value.in_total = document_tax.at_css('УчтеноВСумме').text
          @new_document_tax_value.sum = document_tax.at_css('Сумма').text
        end
        object.documents_tax_values << @new_document_tax_value
        tax.documents_tax_values << @new_document_tax_value
      end
    end

  end


  #парсим реквизиты документа

  def insert_new_document_requisite_value(document_id_xml, value, product_requisite)
    document = Document.find_by(id_xml: document_id_xml)
    @new_document_requisite_value            = DocumentRequisite.new
    @new_document_requisite_value.value      = value
     @new_document_requisite_value.document  = document
     @new_document_requisite_value.requisite = product_requisite
    #@new_document.requisites << @new_document_requisite_value
    #product_requisite.requisites << @new_document_requisite_value

    @new_document_requisite_value.save!
  end



end