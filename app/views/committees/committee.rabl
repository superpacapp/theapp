object @committee

attributes :id, :cmte_id, :cmte_name, :suppopp, :bio

attribute :cmte_name => :committee_name

node :total_raised do |committee|
    number_to_currency(committee.total_raised, {:precision => 0})
end

node :total_spent do |committee|
    number_to_currency(committee.total_spent, {:precision => 0})
end

node :org_type do |committee|
    committee.org_type
end

child :committee_articles => :articles do
    extends "committees/committee_article"
end