module CommercemlCreator


  def create_order_to_erp
    # file = './data/to_ERP/to.xml'
    # doc = File.new(file, "w")
    # doc.close

    commerce_infor = CommerceInformation.find_by(name_document: "from_ERP_order")

    # doc = File.open(file, "a")
    document = create_to_erp_order(commerce_infor)
    # File.write(doc, document.to_xml(:encoding => "UTF-8"))
    # doc.close
    commerce_infor.to_site = true
    commerce_infor.save!
    return document
  end
end