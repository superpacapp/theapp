class RenameClaimsLinksToClaimLink < ActiveRecord::Migration
  def up
    rename_table :claims_links, :claim_links
  end

  def down
    rename_table :claim_links, :claims_links
  end
end
