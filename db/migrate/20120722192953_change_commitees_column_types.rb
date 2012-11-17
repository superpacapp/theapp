class ChangeCommiteesColumnTypes < ActiveRecord::Migration
  def up
    change_table :committees do |t|
      t.change :ind_exp, :decimal, :precision => 11, :scale => 2
      t.change :total_raised, :decimal, :precision => 11, :scale => 2
      t.change :total_spent, :decimal, :precision => 11, :scale => 2
      t.change :total_elecomm_spending, :decimal, :precision => 11, :scale => 2
      t.change :total_comm_cost_spending, :decimal, :precision => 11, :scale => 2
      t.change :total_coordexp_spending, :decimal, :precision => 11, :scale => 2
      t.change :total_demfor, :decimal, :precision => 11, :scale => 2
      t.change :total_demagnst, :decimal, :precision => 11, :scale => 2
      t.change :total_repubfor, :decimal, :precision => 11, :scale => 2
      t.change :total_repubagnst, :decimal, :precision => 11, :scale => 2
      t.change :total_cash_on_hand, :decimal, :precision => 11, :scale => 2
      t.change :total_outside, :decimal, :precision => 11, :scale => 2
      t.change :total_raised, :decimal, :precision => 11, :scale => 2
      t.change :total_raised, :decimal, :precision => 11, :scale => 2
    end
  end

  def down
  end
end