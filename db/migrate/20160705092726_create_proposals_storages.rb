class CreateProposalsStorages < ActiveRecord::Migration[5.0]
  def change
    create_table :proposals_storages do |t|
      t.string :quantity
      t.integer :proposal_id
      t.integer :storage_id
      t.timestamps
    end
  end
end
