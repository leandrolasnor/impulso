class CreateContact < ActiveRecord::Migration[7.1]
  def change
    create_table :contacts do |t|
      t.string :number, null: false
      t.integer :proponent_id, null: false

      t.timestamps
    end

    add_foreign_key :addresses, :proponents, column: :proponent_id
  end
end
