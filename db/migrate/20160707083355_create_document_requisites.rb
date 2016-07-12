class CreateDocumentRequisites < ActiveRecord::Migration[5.0]
  def change
    create_table :document_requisites do |t|
      t.integer :document_id
      t.integer :requisite_id
      t.string :value
      t.timestamps
    end
  end
end
