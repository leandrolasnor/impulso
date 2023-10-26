class CreateAddress < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :address, null: false
      t.string :number, null: true
      t.string :district, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip, null: false
      t.integer :proponent_id, null: false

      t.timestamps
    end

    add_foreign_key :addresses, :proponents, column: :proponent_id
    add_index :addresses, :zip, unique: true
  end
end
