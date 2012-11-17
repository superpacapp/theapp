object @claim

attributes :claim => :claim_text
child :claim_details => :claim_sources do
	extends "claims/claim_detail"
end