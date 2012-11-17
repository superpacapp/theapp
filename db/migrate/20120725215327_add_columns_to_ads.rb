class AddColumnsToAds < ActiveRecord::Migration
  def change
    add_column :ads, :love, :integer, :default => 0, :limit => 8
    add_column :ads, :fair, :integer, :default => 0, :limit => 8
    add_column :ads, :fishy, :integer, :default => 0, :limit => 8
    add_column :ads, :fail, :integer, :default => 0, :limit => 8
  end
end
