class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :displayname
      t.string :email
      t.boolean :is_admin
      t.timestamps
    end
    add_index :users, :username, :unique => true
  end
end
