class CreateClaimDetails < ActiveRecord::Migration
  def change
    create_table :claim_details do |t|
      t.integer :claim_id
      t.string :source_name
      t.string :source_url
      t.string :source_title
      t.string :source_type

    end
  end
end
