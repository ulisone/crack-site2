class CreateDownloads < ActiveRecord::Migration[8.0]
  def change
    create_table :downloads do |t|
      t.references :software, null: false, foreign_key: true
      t.string :ip_address, null: false
      t.text :user_agent
      t.string :file_name

      t.timestamps
    end
    
    add_index :downloads, :created_at
    add_index :downloads, [:software_id, :created_at]
    add_index :downloads, :ip_address
  end
end
