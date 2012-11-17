class RemoveTimestampsFromAds < ActiveRecord::Migration
  def up
    remove_column :ads, :created_at
    remove_column :ads, :updated_at
  end

  def down
  end
end
