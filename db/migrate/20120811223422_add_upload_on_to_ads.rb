class AddUploadOnToAds < ActiveRecord::Migration
  def change
    add_column :ads, :upload_on, :date
  end
end
