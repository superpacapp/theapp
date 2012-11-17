class CreateAdsAndClaimsAssociation < ActiveRecord::Migration
  def change
      create_table :ads_claims, :id => false do |t|
        t.integer :ad_id
        t.integer :claim_id
      end
    end
  end