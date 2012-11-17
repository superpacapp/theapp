class RemoveTimestampsFromClaims < ActiveRecord::Migration
  def up
    remove_column :claims, :created_at
    remove_column :claims, :updated_at
  end

  def down
  end
end
