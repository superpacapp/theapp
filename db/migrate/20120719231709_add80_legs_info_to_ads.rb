class Add80LegsInfoToAds < ActiveRecord::Migration
  def up
    add_column :ads, :meta_desc, :string
    add_column :ads, :meta_keywords, :string
    add_column :ads, :video_id, :string
    add_column :ads, :down_votes, :integer
    add_column :ads, :num_view, :integer
    add_column :ads, :up_votes, :integer
    add_column :ads, :user_name, :string
    add_column :ads, :category_name, :string
    add_column :ads, :tags, :text
    add_column :ads, :license_name, :string
  end

  def down
    remove_column :ads, :meta_desc, :string
    remove_column :ads, :meta_keywords, :string
    remove_column :ads, :video_id, :string
    remove_column :ads, :down_votes, :integer
    remove_column :ads, :num_view, :integer
    remove_column :ads, :up_votes, :integer
    remove_column :ads, :user_name, :string
    remove_column :ads, :category_name, :string
    remove_column :ads, :tags, :text
    remove_column :ads, :license_name, :string
  end
end
