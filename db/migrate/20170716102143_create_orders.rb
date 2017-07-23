class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.integer :no
      t.string :agent_id

      t.timestamps
    end
    add_index :orders, :no, unique: true
  end
end
