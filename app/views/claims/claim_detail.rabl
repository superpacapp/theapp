object @claim_detail => :claim_source

#attribute :source_title => :source_name

node(:source_name) {|m| m.short_title}

attributes :source_url, :source_type

attribute :source_name => :src_name

attribute :source_title => :src_title
