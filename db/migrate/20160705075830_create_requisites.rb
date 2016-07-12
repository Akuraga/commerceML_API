class CreateRequisites < ActiveRecord::Migration[5.0]
  def change
    create_table :requisites do |t|
      t.string :name
      t.timestamps
    end
  end
end
