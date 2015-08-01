class CreateVoteSummaries < ActiveRecord::Migration
  def change
    create_table :vote_summaries do |t|
      t.integer :election_id
      t.integer :candidate_id
      t.integer :total_votes, default: 0

      t.timestamps null: false
    end
  end
end
