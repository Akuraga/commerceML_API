module AddressParser

  #парсим адрес если встречаем 'АдресноеПоле'

  def parse_address(object, address_fields)
    address_fields.each do |address_field|
      case address_field.css('Тип').text
        when 'Почтовый индекс'
          object.post_index = address_field.css('Значение').text
        when 'Страна'
          object.country = address_field.css('Значение').text
        when 'Регион'
          object.region = address_field.css('Значение').text
        when 'Район'
          object.area = address_field.css('Значение').text
        when 'Населенный пункт'
          object.city = address_field.css('Значение').text
        when 'Город'
          object.city = address_field.css('Значение').text
        when 'Улица'
          object.street = address_field.css('Значение').text
        when 'Дом'
          object.build = address_field.css('Значение').text
        when 'Корпус'
          object.housing = address_field.css('Значение').text
        when 'Квартира'
          object.flat = address_field.css('Значение').text
      end
    end
  end
end