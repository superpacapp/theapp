class AddUserNameToCommittees < ActiveRecord::Migration
  def change
    add_column :committees, :user_name, :string
  end
end
