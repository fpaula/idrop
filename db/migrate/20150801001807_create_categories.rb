class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :parent_id
      t.string :language, limit: 5, default: 'pt-br'
      t.boolean :status, default: true
      t.string :slug

      t.timestamps null: false
    end

    add_index :categories, :slug
  end
end