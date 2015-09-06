class AddLicenseFieldsToImages < ActiveRecord::Migration
  def change
    add_column :candidates, :image_original_title, :string
    add_column :candidates, :image_original_url, :string
    add_column :candidates, :image_author_name, :string
    add_column :candidates, :image_author_url, :string
    add_column :candidates, :image_license, :string
  end
end
