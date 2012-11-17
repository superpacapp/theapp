object @ad

attributes :id, :title, :thumbnail_url, :length, :url, :upload_date, :upload_on, :view_count

node(:upload_date){|ad| ad.pretty_date }

node(:updated_at){|ad| ad.updated_date}

node(:upload_on){|ad| ad.upload_on}

node :tags do |ad|

    {love: number_with_precision(ad.love_tag.to_f/ad.tag_count.to_f, :precision =>2).to_f, fair:number_with_precision(ad.fair_tag.to_f/ad.tag_count.to_f,:precision =>2).to_f, fishy:number_with_precision(ad.fishy_tag.to_f/ad.tag_count.to_f, :precision =>2).to_f, fail:number_with_precision(ad.fail_tag.to_f/ad.tag_count.to_f, :precision =>2).to_f}

end

child :claims => :claims do
    extends "claims/show"
end