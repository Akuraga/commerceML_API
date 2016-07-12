class CreateCommerceInformations < ActiveRecord::Migration[5.0]
  def change
    create_table :commerce_informations do |t|
      t.string :name_document
      t.string :version
      t.string :date
      t.boolean :from_erp
      t.boolean :from_site
      t.boolean :to_erp
      t.boolean :to_site
      t.timestamps
    end
  end
end
