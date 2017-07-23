class CreateSales < ActiveRecord::Migration[5.1]
  def change
    create_table :sales do |t|
      t.integer :order_no
      t.string :product_sid
      t.decimal :sale_price, precision: 8, scale: 2
      t.integer :amount, default: 1

      t.timestamps
    end
    add_index :sales, :order_no
    add_index :sales, :product_sid
  end
end
