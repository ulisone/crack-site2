class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.integer :position, default: 0
      t.integer :softwares_count, default: 0

      t.timestamps
    end
    
    add_index :categories, :slug, unique: true
    add_index :categories, :position
    add_index :categories, :name, unique: true
  end
end
