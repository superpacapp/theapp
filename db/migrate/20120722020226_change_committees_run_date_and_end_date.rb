class ChangeCommitteesRunDateAndEndDate < ActiveRecord::Migration
  def self.up
      change_table :committees do |t|
        t.change :run_date, :string
        t.change :end_date, :string
      end
    end

    def self.down
      change_table :committees do |t|
        t.change :run_date, :date
        t.change :end_date, :date
      end
    end
end
