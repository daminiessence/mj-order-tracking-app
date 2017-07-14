class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.boolean :admin, default: false

      t.string :remember_me_digest

      t.string :password_digest
      t.string :password_reset_digest
      t.datetime :password_reset_sent_at

      t.string :agent_id

      t.boolean :activated, default: false
      t.datetime :activated_at
      t.string :activation_digest

      t.timestamps
    end
  end
end
