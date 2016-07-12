class CreateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :documents do |t|
      t.string :id_xml
      t.string :number
      t.string :date
      t.string :economic_op
      t.string :role
      t.string :currency
      t.string :course
      t.string :sum
      t.string :time
      t.string :payment_term
      t.string :comment
      t.integer :commerce_information_id
      t.timestamps
    end
  end
end
