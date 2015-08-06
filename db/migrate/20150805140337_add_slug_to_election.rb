class AddSlugToElection < ActiveRecord::Migration
  def change
    add_column :elections, :slug, :string
    add_index :elections, :slug
  end
end