class RemoveTagIdFromAds < ActiveRecord::Migration
  def up
    remove_column :ads, :tag_id
      end

  def down
    add_column :ads, :tag_id, :integer
  end
end
