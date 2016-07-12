class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.string :contact_type
      t.string :value
      t.string :comment
      t.integer :contactable_id
      t.string :contactable_type
      t.timestamps
    end
  end
end
