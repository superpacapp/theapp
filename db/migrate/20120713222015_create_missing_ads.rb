class CreateMissingAds < ActiveRecord::Migration
  def change
    create_table :missing_ads do |t|
      t.string :network
      t.text :message

      t.timestamps
    end
  end
end
