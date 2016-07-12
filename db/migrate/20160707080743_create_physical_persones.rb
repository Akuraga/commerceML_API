class CreatePhysicalPersones < ActiveRecord::Migration[5.0]
  def change
    create_table :physical_persones do |t|
      t.string :full_name
      t.string :appeal
      t.string :first_name
      t.string :last_name
      t.string :patronymic
      t.string :date_birth
      t.string :inn
      t.string :kpp
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
      t.integer :identity_card_id
      t.timestamps
    end
  end
end
