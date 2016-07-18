module ClassifierParser
  #разбираем Классификатор

  def parse_classifier(classifier_doc, commerce_information)
    @new_classifier             = Classifier.new
    @new_classifier.id_xml      = classifier_doc.at_css('Ид').text
    @new_classifier.name        = classifier_doc.at_css('Наименование').text
    @new_classifier.only_change = classifier_doc.css('Классификатор')[0]['СодержитТолькоИзменения']
    if classifier_doc.at_css('Владелец')
      parse_owner(classifier_doc.css('Владелец'))
    end

    @new_ownner.classifiers << @new_classifier
    commerce_information.classifiers << @new_classifier

    if classifier_doc.at_css('Группы')
      parse_group(classifier_doc.css('Группы'))
    end

    if classifier_doc.at_css('Свойства')
      parse_property(classifier_doc.css('Свойства'))
    end
  end


  #разбираем владельца

  def parse_owner(owner_doc)
    @new_ownner = Owner.new
    @new_ownner.id_xml = owner_doc.at_css('Ид').text
    @new_ownner.name = owner_doc.at_css('Наименование').text
    @new_ownner.official_name = owner_doc.at_css('ОфициальноеНаименование').text
    @new_ownner.address = owner_doc.at_css('ЮридическийАдрес Представление').text
    if owner_doc.css('ЮридическийАдрес АдресноеПоле').text != ""
      parse_address(@new_ownner, owner_doc.css('ЮридическийАдрес АдресноеПоле'))
    end
    @new_ownner.inn = owner_doc.at_css('ИНН').text
    if owner_doc.at_css('КПП')
      @new_ownner.kpp = owner_doc.at_css('КПП').text
    end
    if owner_doc.at_css('ОКПО')
      @new_ownner.okpo = owner_doc.at_css('ОКПО').text
    end

    @new_ownner.save!

    if owner_doc.at_css('РасчетныеСчета')
      parse_payment_account(owner_doc.css('РасчетныеСчета'))
    end
    return @new_ownner
  end


  #разбираем расчетные счета

  def parse_payment_account(payment_accounts)
    @new_payment_account = PaymentAccount.new
    @new_payment_account.owner = @new_ownner
    payment_accounts.each do |payment_account|
      @new_payment_account.payment_account = payment_account.at_css('НомерСчета').text
      @new_payment_account.save!
      if payment_account.at_css('Банк')
        parse_bank(payment_account.css('Банк'), false)
      end
      if payment_account.at_css('БанкКорреспондент')
        parse_bank(payment_account.css('БанкКорреспондент'), true)
      end
    end
  end


  #разбираем банки

  def parse_bank(bank,corespondent_bank)
    @new_bank = Bank.new
    @new_bank.payment_account = @new_payment_account
    @new_bank.corespondent_bank = corespondent_bank
    @new_bank.name = bank.at_css('Наименование').text
    @new_bank.correspondent_account = bank.at_css('СчетКорреспондентский').text
    @new_bank.address = bank.at_css('Представление').text
    if bank.at_css('Адрес АдресноеПоле')
      parse_address(@new_bank, bank.css('Адрес АдресноеПоле'))
    end
    @new_bank.bik = bank.at_css('БИК').text
    @new_bank.save!
  end


  #Парсим группы

  def parse_group(group_doc)
    Nokogiri::XML::SAX::Parser.new(Parser.new).parse(group_doc.to_xml)
  end


  #Парсим свойства классификатора

  def parse_property(property_doc)
    property_doc.css('Свойство').each do |property|
      @new_property             = Property.new
      @new_property.id_xml      = property.at_css('Ид').text
      @new_property.name        = property.at_css('Наименование').text
      @new_property.value       = property.at_css('ТипЗначений').text
      if property.at_css('ДляТоваров')
        @new_property.for_product = property.at_css('ДляТоваров').text
      end
      @new_classifier.properties << @new_property
      if property.at_css('Справочник')
        parser_handbook(property.css('Справочник'))
      end
    end
  end


  #парсим справочники

  def parser_handbook(handbook_doc)
    handbook_doc.each do |handbook|
      @new_handbook = Handbook.new
      @new_handbook.id_xml = handbook.at_css('ИдЗначения').text
      @new_handbook.value = handbook.at_css('Значение').text
      @new_property.handbooks << @new_handbook
    end
  end
end
