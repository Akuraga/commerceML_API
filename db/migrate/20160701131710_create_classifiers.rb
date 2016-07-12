class CreateClassifiers < ActiveRecord::Migration[5.0]
  def change
    create_table :classifiers do |t|
      t.string :id_xml
      t.string :name
      t.string :only_change
      t.integer :owner_id
      t.integer :commerce_information_id
      t.timestamps
    end
  end
end
