class AddSourceToClaimLinks < ActiveRecord::Migration
  def change
    add_column :claim_links, :source, :string
  end
end
