class CreateProponent < ActiveRecord::Migration[7.1]
  def change
    create_table :proponents do |t|
      t.string :name, null: false
      t.string :taxpayer_number, null: false
      t.date :birthdate, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.decimal :discount_amount, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
