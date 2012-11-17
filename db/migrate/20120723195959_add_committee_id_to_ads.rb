class AddCommitteeIdToAds < ActiveRecord::Migration
  def change
    add_column :ads, :committee_id, :integer
  end
end
