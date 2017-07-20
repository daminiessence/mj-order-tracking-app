class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :sid
      t.string :name
      t.text :description
      t.decimal :suggested_price, precision: 8, scale: 2

      t.timestamps
    end
    add_index :products, :sid
  end
end
