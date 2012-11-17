class AddUploadDateToAds < ActiveRecord::Migration
  def change
    add_column :ads, :upload_date, :string
  end
end
