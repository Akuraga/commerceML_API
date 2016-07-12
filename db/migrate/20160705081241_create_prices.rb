class CreatePrices < ActiveRecord::Migration[5.0]
  def change
    create_table :prices do |t|
      t.string :presentation
      t.string :price
      t.string :coefficient
      t.string :currency
      t.string :unit
      t.integer :proposal_id
      t.integer :price_type_id
      t.timestamps
    end
  end
end
