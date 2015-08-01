class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.string :name
      t.string :nickname
      t.string :image_url
      t.boolean :status

      t.timestamps null: false
    end
  end
end
