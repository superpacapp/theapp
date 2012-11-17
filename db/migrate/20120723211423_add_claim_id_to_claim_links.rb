class AddClaimIdToClaimLinks < ActiveRecord::Migration
  def change
    add_column :claim_links, :claim_id, :integer
    add_column :claim_links, :claim_type, :string
  end
end
