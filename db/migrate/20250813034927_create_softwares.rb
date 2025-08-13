class CreateSoftwares < ActiveRecord::Migration[8.0]
  def change
    create_table :softwares do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :version, null: false
      t.string :developer
      t.string :official_site
      t.bigint :file_size
      t.string :os_requirements
      t.boolean :published, default: false
      t.integer :downloads_count, default: 0
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :softwares, :published
    add_index :softwares, :created_at
    add_index :softwares, :title
    add_index :softwares, [:category_id, :published]
  end
end
