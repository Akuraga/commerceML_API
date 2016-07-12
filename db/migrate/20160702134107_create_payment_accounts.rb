class CreatePaymentAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :payment_accounts do |t|
      t.string :payment_account
      t.integer :owner_id
      t.timestamps
    end
  end
end
