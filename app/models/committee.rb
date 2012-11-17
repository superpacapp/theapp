class Committee < ActiveRecord::Base
  attr_accessible :cmte_id, :cmte_name, :suppopp, :total_raised, :total_spent, :org_type
  has_many :ads
  has_many :tagged_ads, :through => :ads
  has_many :committee_articles

  def ads_list
    self.ads.map{|a| a.id.to_i}
  end
end

