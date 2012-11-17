class DropLicenseNameFromAds < ActiveRecord::Migration
  def up
  	remove_column :ads, :meta_desc
  	remove_column :ads, :meta_keywords
  	remove_column :ads, :tags
  	remove_column :ads, :license_name
  	remove_column :ads, :num_view
  	remove_column :ads, :up_votes
  	remove_column :ads, :down_votes
  	remove_column :ads, :category_name
  end

  def down
  end
end
