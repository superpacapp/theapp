class CommitteeArticle < ActiveRecord::Base
  attr_accessible :committee_id, :source, :title, :url
  belongs_to :committee
end
