class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :attachment_file_name
      t.string :attachment_link_text
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.datetime :attachment_updated_at
      t.references :nursing_home

      t.timestamps
    end
    add_index :attachments, :nursing_home_id
  end
end
