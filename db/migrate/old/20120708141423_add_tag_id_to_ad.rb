class AddTagIdToAd < ActiveRecord::Migration
  def change
    add_column :ads, :tag_id, :integer
  end
end
