object @claim

attribute :claim
child :claim_details => :claim_sources do
	attributes :source_url, :source_name
end


