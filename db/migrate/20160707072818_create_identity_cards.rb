class CreateIdentityCards < ActiveRecord::Migration[5.0]
  def change
    create_table :identity_cards do |t|
      t.string :type_document
      t.string :series
      t.string :number
      t.string :issue_date
      t.string :issued_by
      t.integer :physical_persone_id
      t.timestamps
    end
  end
end
