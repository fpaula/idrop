class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :parent_id
      t.string :language, limit: 5, default: 'pt-br'
      t.boolean :status, default: true

      t.timestamps null: false
    end
  end
end