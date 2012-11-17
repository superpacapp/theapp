class AddViewCountAndLastViewedToAd < ActiveRecord::Migration
  def change
    add_column :ads, :view_count, :integer
  end
end
