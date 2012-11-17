object @ad

attributes :id, :video_id, :uuid, :title, :thumbnail_url, :length, :url, :view_count

node(:upload_date){|ad| ad.pretty_date}

node(:upload_on){|ad| ad.upload_on}

node(:updated_at){|ad| ad.updated_date}

node :tags do |ad|

    {love: number_with_precision(ad.love_tag.to_f/ad.tag_count.to_f, :precision =>2).to_f, fair:number_with_precision(ad.fair_tag.to_f/ad.tag_count.to_f,:precision =>2).to_f, fishy:number_with_precision(ad.fishy_tag.to_f/ad.tag_count.to_f, :precision =>2).to_f, fail:number_with_precision(ad.fail_tag.to_f/ad.tag_count.to_f, :precision =>2).to_f}

end

child :claims => :claims do
    extends "claims/show"
end

child :committee do
    extends "committees/committee"
end

