class CreateContractors < ActiveRecord::Migration[5.0]
  def change
    create_table :contractors do |t|
      t.string :id_xml
      t.string :name
      t.string :role
      t.integer :personable_id
      t.string :personable_type
      t.timestamps
    end
  end
end
