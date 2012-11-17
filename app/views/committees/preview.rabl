collection @committees => :committees
   
   attributes :id, :cmte_id, :cmte_name
   attribute :cmte_name => :committee_name
   node(:ad_ids){|committee| committee.ads_list}

#node(:code){200}
#node(:status){"OK"}
#node(:message){"success"}
#node(:total) {|m| @committees.count }



