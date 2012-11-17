class CreateCommitteeArticles < ActiveRecord::Migration
  def change
    create_table :committee_articles do |t|
      t.integer :committee_id
      t.string :title
      t.string :url
      t.string :source

    end
  end
end
