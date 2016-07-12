class ContractorsDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :contractors_documents, id: false do |t|
      t.integer :contractor_id
      t.integer :document_id
    end
  end
end
