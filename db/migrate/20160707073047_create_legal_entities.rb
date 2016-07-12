class CreateLegalEntities < ActiveRecord::Migration[5.0]
  def change
    create_table :legal_entities do |t|
      t.string :official_name
      t.string :inn
      t.string :kpp
      t.string :egrpo
      t.string :okpo
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
      t.timestamps
    end
  end
end
