class CreateNursingHomes < ActiveRecord::Migration
  def change
    create_table :nursing_homes do |t|
      t.string :name
      t.text :description
      t.string :address
      t.string :post_code
      t.string :postal_town
      t.string :neighborhood
      t.integer :geo_position_x
      t.integer :geo_position_y
      t.string :phone
      t.string :fax
      t.string :url
      t.string :email

      t.string :type_of
      t.string :owner_type
      t.string :owner
      t.text :standard
      t.integer :seats
      t.integer :quality_environment
      t.integer :quality_activities
      t.integer :quality_food
      t.integer :quality_safety
      t.integer :quality_influence

      t.timestamps
    end
    add_index :nursing_homes, :name
    add_index :nursing_homes, :neighborhood
    add_index :nursing_homes, :type_of
    add_index :nursing_homes, :owner_type
  end
end
