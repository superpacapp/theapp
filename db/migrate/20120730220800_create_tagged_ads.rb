class CreateTaggedAds < ActiveRecord::Migration
  def change
    create_table :tagged_ads do |t|
      t.integer :ad_id
      t.string :tag
      t.float :lat
      t.float :long

      t.timestamps
    end
  end
end
