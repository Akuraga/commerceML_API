class CreateUnits < ActiveRecord::Migration[5.0]
  def change
    create_table :units do |t|
      t.string :name
      t.string :code
      t.string :full_name
      t.string :intern_cut
      t.timestamps
    end
  end
end

