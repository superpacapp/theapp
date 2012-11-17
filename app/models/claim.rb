class Claim < ActiveRecord::Base
  attr_accessible :claim
  has_and_belongs_to_many :ads
  has_many :claim_details

  default_scope  :conditions => 'claim_id != 514'

end
