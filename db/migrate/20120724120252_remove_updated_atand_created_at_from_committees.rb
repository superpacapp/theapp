class RemoveUpdatedAtandCreatedAtFromCommittees < ActiveRecord::Migration
  def up
    remove_column :committees, :created_at
    remove_column :committees, :updated_at
  end

  def down
  end
end
