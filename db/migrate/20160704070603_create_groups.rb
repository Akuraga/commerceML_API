class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string  :id_xml
      t.string  :name
      t.integer :classifier_id
      t.integer :groupable_id
      t.string  :groupable_type

      t.timestamps
    end
  end
end
