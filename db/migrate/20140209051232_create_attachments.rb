class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.binary  :file_content,    limit: 2.megabytes
      t.string  :file_name
      t.string  :mime_type
      t.integer :file_size
      t.integer :event_id
      t.boolean :public, :default => false

      t.timestamps
    end
    add_index :attachments, :event_id
  end
end
