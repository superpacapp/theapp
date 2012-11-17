class AddLengthToAds < ActiveRecord::Migration
  def change
    add_column :ads, :length, :integer
  end
end
