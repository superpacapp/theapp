class CreateSuperpacappcontacts < ActiveRecord::Migration
  def change
    create_table :appcontacts do |t|
      t.string :email

      t.timestamps
    end
  end
end
