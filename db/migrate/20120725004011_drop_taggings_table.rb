class DropTaggingsTable < ActiveRecord::Migration
  def up
    drop_table :taggings
  end

  def down
  end
end
