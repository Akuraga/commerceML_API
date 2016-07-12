class CreateOwners < ActiveRecord::Migration[5.0]
  def change
    create_table :owners do |t|
      t.string :id_xml
      t.string :name
      t.string :official_name
      t.string :name_type
      t.string :comment
      t.string :address
      t.string :post_index
      t.string :country
      t.string :region
      t.string :area
      t.string :city
      t.string :street
      t.string :build
      t.string :housing
      t.string :flat
      t.string :inn
      t.string :kpp
      t.string :okpo
      t.timestamps
    end
  end
end
