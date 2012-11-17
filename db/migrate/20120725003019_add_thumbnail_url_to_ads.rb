class AddThumbnailUrlToAds < ActiveRecord::Migration
  def change
    add_column :ads, :thumbnail_url, :string
  end
end
