class CreateBanks < ActiveRecord::Migration[5.0]
  def change
    create_table :banks do |t|
      t.integer :payment_account_id
      t.boolean :corespondent_bank
      t.string :name
      t.string :correspondent_account
      t.string :bik
      t.string :address
      t.string :post_index
      t.string :country
      t.string :region
      t.string :area
      t.string :city
      t.string :street
      t.string :build
      t.string :housing
      t.string :flat
      t.timestamps
    end
  end
end
