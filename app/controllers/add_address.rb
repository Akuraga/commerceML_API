module AddAddress

  def add_address_fields(object, node_master, doc)
    node_address_field = Nokogiri::XML::Node.new('АдресноеПоле', doc)
    node_type          = Nokogiri::XML::Node.new('Тип', doc)

    if object.post_index
      node_master.add_child node_address_field
      node_type.content = "Почтовый индекс"
      node_address_field.add_child node_type

      node_post_index = Nokogiri::XML::Node.new('Значение', doc)
      node_post_index.content = "#{object.post_index}"
      node_address_field.add_child node_post_index
    end

    if object.country
      node_master.add_child node_address_field
      node_type.content = "Страна"
      node_address_field.add_child node_type

      node_country = Nokogiri::XML::Node.new('Значение', doc)
      node_country.content = "#{object.country}"
      node_address_field.add_child node_country
    end

    if object.region
      node_master.add_child node_address_field
      node_type.content = "Регион"
      node_address_field.add_child node_type

      node_region = Nokogiri::XML::Node.new('Значение', doc)
      node_.content = "#{object.region}"
      node_address_field.add_child node_region
    end

    if object.area
      node_master.add_child node_address_field
      node_type.content = "Район"
      node_address_field.add_child node_type

      node_area = Nokogiri::XML::Node.new('Значение', doc)
      node_area.content = "#{object.area}"
      node_address_field.add_child node_area
    end

    if object.city
      node_master.add_child node_address_field
      node_type.content = "Населенный пункт"
      node_address_field.add_child node_type

      node_city = Nokogiri::XML::Node.new('Значение', doc)
      node_city.content = "#{object.city}"
      node_address_field.add_child node_city
    end

    if object.street
      node_master.add_child node_address_field
      node_type.content = "Улица"
      node_address_field.add_child node_type

      node_street = Nokogiri::XML::Node.new('Значение', doc)
      node_street.content = "#{object.street}"
      node_address_field.add_child node_street
    end

    if object.build
      node_master.add_child node_address_field
      node_type.content = "Дом"
      node_address_field.add_child node_type

      node_build = Nokogiri::XML::Node.new('Значение', doc)
      node_build.content = "#{object.build}"
      node_address_field.add_child node_build
    end

    if object.housing
      node_master.add_child node_address_field
      node_type.content = "Корпус"
      node_address_field.add_child node_type

      node_housing = Nokogiri::XML::Node.new('Значение', doc)
      node_.content = "#{object.housing}"
      node_address_field.add_child node_housing
    end

    if object.flat
      node_master.add_child node_address_field
      node_type.content = "Квартира"
      node_address_field.add_child node_type

      node_flat = Nokogiri::XML::Node.new('Значение', doc)
      node_flat.content = "#{object.flat}"
      node_address_field.add_child node_flat
    end


  end
end