class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.integer :position
      t.datetime :image_updated_at
      t.references :nursing_home

      t.timestamps
    end
    add_index :images, :nursing_home_id
  end
end
