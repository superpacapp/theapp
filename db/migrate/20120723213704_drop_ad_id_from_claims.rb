class DropAdIdFromClaims < ActiveRecord::Migration
    def change
      remove_column :claims, :ad_id
    end
  end
