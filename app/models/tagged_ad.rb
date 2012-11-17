class TaggedAd < ActiveRecord::Base
  attr_accessible :ad_id, :lat, :long, :tag, :updated_at, :created_at
  belongs_to :ad

  default_scope :order => 'updated_at DESC'

end
