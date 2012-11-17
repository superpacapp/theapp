class AddTunesatCountToAd < ActiveRecord::Migration
  def change
    add_column :ads, :tunesat_count, :integer
  end
end
