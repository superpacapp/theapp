class ChangeTimestampColumnsOnCommittees < ActiveRecord::Migration
  def up
    change_table :committees do |t|
      t.change :created_at, :timestamp, :default => Time.now
      t.change :updated_at, :timestamp, :default => Time.now
    end
  end

  def down
  end
end
