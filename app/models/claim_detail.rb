class ClaimDetail < ActiveRecord::Base
  attr_accessible :claim_id, :source_name, :source_title, :source_type, :source_url

  default_scope :order => :source_title

  def editorial
  	where(:source_type => 'Editorial')
  end

  def factcheck
  	where(:source_type => 'Fact Check')
  end

  def short_title
    if self.source_type == 'Editorial'
    	if self.source_title.length > 22
    		self.source_title.slice(0,22).concat('...')
    	else
    		self.source_title
    	end
    else
      self.source_name
    end
  end
  
end
