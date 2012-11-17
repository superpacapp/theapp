class CreateClaims < ActiveRecord::Migration
  def change
    create_table :claims do |t|
      t.string :claim

      t.timestamps
    end
  end
end
