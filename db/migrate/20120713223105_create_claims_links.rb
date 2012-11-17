class CreateClaimsLinks < ActiveRecord::Migration
  def change
    create_table :claims_links do |t|
      t.string :link

      t.timestamps
    end
  end
end
