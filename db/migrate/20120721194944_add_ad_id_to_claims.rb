class AddAdIdToClaims < ActiveRecord::Migration
  def change
    add_column :claims, :ad_id, :integer
  end
end
