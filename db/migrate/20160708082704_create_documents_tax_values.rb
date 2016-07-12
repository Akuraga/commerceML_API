class CreateDocumentsTaxValues < ActiveRecord::Migration[5.0]
  def change
    create_table :documents_tax_values do |t|
      t.integer :document_id
      t.integer :tax_id
      t.string :in_total
      t.string :sum
      t.timestamps
    end
  end
end
