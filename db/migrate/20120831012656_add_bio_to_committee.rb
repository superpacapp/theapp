class AddBioToCommittee < ActiveRecord::Migration
  def change
    add_column :committees, :bio, :text
  end
end
