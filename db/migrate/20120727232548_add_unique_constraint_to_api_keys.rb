class AddUniqueConstraintToApiKeys < ActiveRecord::Migration
  def change
    add_index :api_keys, :owner, :unique => true
  end
end
