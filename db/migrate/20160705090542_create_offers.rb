class CreateOffers < ActiveRecord::Migration[5.0]
  def change
    create_table :offers do |t|
      t.string :only_change
      t.string :id_xml
      t.string :name
      t.integer :classifier_id
      t.integer :catalog_id
      t.integer :owner_id
      t.integer :commerce_information_id
      t.timestamps
    end
  end
end
