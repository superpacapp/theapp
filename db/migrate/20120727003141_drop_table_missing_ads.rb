class DropTableMissingAds < ActiveRecord::Migration
  def up
    drop_table :missing_ads
  end

  def down
  end
end
