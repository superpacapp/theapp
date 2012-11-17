class AddUuidToAds < ActiveRecord::Migration
  def change
    add_column :ads, :uuid, :string, :unique => true
  end
end
