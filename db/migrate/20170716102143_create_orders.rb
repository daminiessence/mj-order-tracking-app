class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.integer :no
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :orders, :no, unique: true
  end
end
