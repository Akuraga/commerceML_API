class ParserDocument < Nokogiri::XML::SAX::Document
  include OrderParser

  def initialize
    @master = 0
    @insert_requisite = false
    @insert_id_document = false
    @document_id_xml = ''
  end

  def start_element(name, attrs = [])
    @master +=1
    if name == 'Документ'
      @insert_id_document = true
    end
    if @insert_id_document == true and name == 'Ид'
      @insert_id_document = false
      @name_tag = 'Документ Ид'
    end
    if name == 'ЗначенияРеквизитов' and @master == 2
      @insert_requisite = true
    end
    if @insert_requisite == true
      if name == 'Наименование'
        @name_tag = 'Наименование'
      end
      if name == 'Значение'
        @name_tag = 'Значение'
      end
    end
  end


  def characters(data)
    if @name_tag == 'Документ Ид'
      @document_id_xml = data
    end

    if @name_tag == 'Наименование'
      @document_requisite = Requisite.find_by(name: data)
      @name_requisite = data
    end
    if @name_tag == 'Значение'
      if @document_requisite
        insert_new_document_requisite_value(@document_id_xml, data, @document_requisite)
      else
        @new_requisite = Requisite.new
        @new_requisite.name = @name_requisite
        @new_requisite.save!
        insert_new_document_requisite_value(@document_id_xml, data, @new_requisite)
      end
    end
    @name_tag = ''
  end


  def end_element(name)
    @master -= 1
  end

end


