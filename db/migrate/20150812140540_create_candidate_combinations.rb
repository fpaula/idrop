class CreateCandidateCombinations < ActiveRecord::Migration
  def change
    create_table :candidate_combinations do |t|
      t.integer :election_id
      t.integer :candidate_id_1
      t.integer :candidate_id_2
    end

    add_foreign_key :candidate_combinations, :elections, on_delete: :cascade
    add_foreign_key :candidate_combinations, :candidates, column: :candidate_id_1, primary_key: :id, on_delete: :cascade
    add_foreign_key :candidate_combinations, :candidates, column: :candidate_id_2, primary_key: :id, on_delete: :cascade
    add_index :candidate_combinations, :election_id, :name => 'index_candidate_combinations_election_id'
  end
end