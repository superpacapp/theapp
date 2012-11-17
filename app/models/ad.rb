class Ad < ActiveRecord::Base
  require 'date'
  attr_accessible :cmte_id, :title, :url, :love, :fail, :fishy, :fair, :upload_date 
  belongs_to :committee
  has_and_belongs_to_many :claims
  has_many :tagged_ads, :order => 'updated_at DESC'

  #default_scope :order => 'upload_on desc'

  def love_tag
    #self.tagged_ads.where("tag='love'").count
    self.love
  end

  def fair_tag
    #self.tagged_ads.where("tag='fair'").count
    self.fair
  end

  def fishy_tag
    #self.tagged_ads.where("tag='fishy'").count
    self.fishy
  end

  def fail_tag
    #self.tagged_ads.where("tag='fail'").count
    self.fail
  end

  def tag_count
    #self.tagged_ads.count
    self.love+self.fair+self.fishy+self.fail
  end

  def now_tag
    @tagged_ad = self.tagged_ads.first
    #@tagged_ad.tag
  end

  def updated_date
    if self.tagged_ads.count > 0
      self.tagged_ads.first.updated_at
    else
      self.upload_on
    end
  end

  def pretty_date
    self.upload_on.strftime('%b %e, %Y')
  end

end
