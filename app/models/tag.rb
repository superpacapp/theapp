class Tag < ActiveRecord::Base
  attr_accessible :name
  #belongs_to :tagged_ad, :foreign_key => :name
  #belongs_to :ad
end
