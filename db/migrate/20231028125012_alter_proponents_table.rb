class AlterProponentsTable < ActiveRecord::Migration[7.1]
  def change
    add_column :proponents, :fee, :string, null: false, default: 0
    add_index :proponents, :fee
  end
end
