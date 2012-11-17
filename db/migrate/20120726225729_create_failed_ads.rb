class CreateFailedAds < ActiveRecord::Migration
  def change
    create_table :failed_ads do |t|
      t.float :lat
      t.float :long
      t.string :suppopp
      t.string :candidate
      t.text :comment

      t.timestamps
    end
  end
end
