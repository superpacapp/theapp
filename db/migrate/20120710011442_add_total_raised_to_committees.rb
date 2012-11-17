class AddTotalRaisedToCommittees < ActiveRecord::Migration
  def change
    add_column :committees, :total_outside, :decimal, :precision => 7, :scale => 2
  end
end
