class AddModifiedImageToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :modified_image_id, :string
  end
end
