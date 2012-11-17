class AddIndExpToCommittees < ActiveRecord::Migration
  def change
    add_column :committees, :ind_exp, :decimal, :precision => 7, :scale => 2
  end
end
