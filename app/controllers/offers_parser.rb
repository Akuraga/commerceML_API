module OffersParser

  def parse_offer(offer_doc, commerce_information)
    @new_offer = Offer.new
    offer_doc                 = offer_doc.css('ПакетПредложений')
    @new_offer.only_change    = offer_doc.css('ПакетПредложений')[0]['СодержитТолькоИзменения']
    @new_offer.id_xml         = offer_doc.at_css('Ид').text
    @new_offer.name           = offer_doc.at_css('Наименование').text
    catalog                   = Catalog.find_by(id_xml: offer_doc.at_css('ИдКаталога').text)
    classifier                = Classifier.find_by(id_xml: offer_doc.at_css('ИдКлассификатора').text)
    owner                     = Owner.find_by(id_xml: offer_doc.at_css('Владелец Ид').text)
    unless owner
     owner = parse_owner(offer_doc.css('Владелец'))
    end
    catalog.offers << @new_offer
    classifier.offers << @new_offer
    owner.offers << @new_offer
    commerce_information.offers << @new_offer

    if offer_doc.at_css('ТипыЦен')
      parse_price_type(offer_doc.css('ТипыЦен'))
    end

    if offer_doc.at_css('Склады')
      parse_storage(offer_doc.css('Склады'))
    end

    if offer_doc.at_css('Предложения')
      parse_proposal(offer_doc.css('Предложения'))
    end



  end


  #парсим ТипыЦен

  def parse_price_type(price_type_doc)
    price_type_doc.css('ТипЦены').each do |price_type|
      @new_price_type             = PriceType.new
      @new_price_type.id_xml      = price_type.at_css('Ид').text
      @new_price_type.name        = price_type.at_css('Наименование').text
      @new_price_type.currency    = price_type.at_css('Валюта').text
      @new_offer.price_type << @new_price_type
      #@new_price_type.save!
      parse_price_type_taxes(price_type.css('Налог'))
    end
  end


  #парсим налоги у ТипЦены

  def parse_price_type_taxes(price_type_tax_doc)
    price_type_tax_doc.css('Налог').each do |price_type_tax|
      tax = Tax.find_by(name: price_type_tax.at_css('Наименование').text)
      if tax
        insert_price_type_tax_value(price_type_tax.at_css('УчтеноВСумме').text, tax)
      else
        @new_tax      = Tax.new
        @new_tax.name = price_type_tax.at_css('Наименование').text
        @new_tax.save!
        insert_price_type_tax_value(price_type_tax.at_css('УчтеноВСумме').text, @new_tax)
      end
    end
  end

  def insert_price_type_tax_value(value, tax)
    @new_price_type_tax_value               = PriceTypeTaxValue.new
    @new_price_type_tax_value.value         = value
    tax.price_type_tax_values << @new_price_type_tax_value
    @new_price_type.price_type_tax_values << @new_price_type_tax_value
  end


  #парсим склады

  def parse_storage(storage_doc)
    storage_doc.css('Склад').each do |storage|
      @new_storage        = Storage.new
      @new_storage.id_xml = storage.at_css('Ид').text
      @new_storage.name   = storage.at_css('Наименование').text
      @new_storage.save!
    end
  end


  #парсим Предложения

  def parse_proposal(proposal_doc)
    proposal_doc.css('Предложение').each do |proposal|
      if proposal.at_css('Ид')
        @new_proposal          = Proposal.new
        @new_proposal.quantity = proposal.at_css('Количество').text
        @new_proposal.save!


        if proposal.at_css('Цены')
          parse_price(proposal.css('Цены'))
        end

        if proposal.at_css('Склад')
          proposal.css('Склад').count.times do |i|
            storage = Storage.find_by(id_xml: proposal.css('Склад')[i]['ИдСклада'])
            proposal_storage          = ProposalsStorage.new
            proposal_storage.quantity = proposal.css('Склад')[i]['КоличествоНаСкладе']
            @new_proposal.proposals_storages << proposal_storage
            storage.proposals_storages << proposal_storage
          end
        end
        product = Product.find_by(id_xml: proposal.at_css('Ид').text)

        @new_proposal.product_id = product.id
        @new_proposal.save!

      end
    end
  end


  #парсим цены

  def parse_price(price_doc)
    price_doc.css('Цена').each do |price|
      @new_price              = Price.new
      @new_price.presentation = price.at_css('Представление').text
      @new_price.price        = price.at_css('ЦенаЗаЕдиницу').text
      @new_price.coefficient  = price.at_css('Коэффициент').text
      @new_price.currency     = price.at_css('Валюта').text
      @new_price.unit         = price.at_css('Единица').text
      @new_proposal.prices << @new_price
      price_type = PriceType.find_by(id_xml: price.at_css('ИдТипаЦены').text)

      price_type.prices << @new_price
    end
  end

end