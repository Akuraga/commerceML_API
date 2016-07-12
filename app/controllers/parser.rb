class Parser < Nokogiri::XML::SAX::Document
  def initialize
    @master = 0
    @classifier = Classifier.last
    @new_group = Hash.new
  end

  def start_element(name, attrs = [])
    if name == 'Группы'
      @master += 1
    end
    if name == 'Группа'
      @new_group[@master] = Group.new
      @new_group[@master].id_xml = ""
      @new_group[@master].name = ""
    end
    if name == 'Ид'
      @tag = 'Ид'
    end
    if name == 'Наименование'
      @tag = 'Наименование'
    end
  end


  def characters(data)
    if @tag == 'Ид'
      @new_group[@master].id_xml += data
    end
    if @tag == 'Наименование'
      @new_group[@master].name += data
      @new_group[@master].classifier = @classifier
      if @master == 1
        @classifier.groups << @new_group[@master]
      else
        @new_group[@master-1].groups << @new_group[@master]
      end
    end
  end


  def end_element(name)
    if name == 'Группы'
      @master -= 1
    end
    if name == 'Ид' or name == 'Наименование'
      @tag = ''
    end
  end
end
