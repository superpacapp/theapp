class AddUrlToCommittee < ActiveRecord::Migration
  def change
    add_column :committees, :url, :string
  end
end
