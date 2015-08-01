class CreateCandidateCategory < ActiveRecord::Migration
  def change
    create_table :candidates_categories do |t|
      t.integer :category_id
      t.integer :candidate_id
      t.timestamps
    end
    add_index :candidates_categories, [:category_id, :candidate_id]
  end
end
