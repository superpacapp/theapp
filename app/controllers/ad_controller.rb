class AdController < ActionController::API
  include ActionController::MimeResponds

  #GET /ads
  def index
    #@ads = Ad.includes(:claims, :tags).all
    @ads = Ad.order('upload_on DESC').includes({:claims => :claim_details}, :committee)

    render "ads/index"

  end

  #GET /ads/1
  def show

    @ad = Ad.find_by_id(params[:id], :include => {:claims => :claim_details}, :include => :committee, :include => :tagged_ads)

    @ad.increment! :view_count

    render "ads/show"
  end

   #GET /ads/tunesat/:uuid
  def tunesat

    @ad = Ad.find_by_uuid(params[:uuid], :include => {:claims => :claim_details}, :include => :committee)

    @ad.increment! :tunesat_count

    render "ads/show"
  end

  #POST ads/id_of_ad/tag/id_of_tag
  def add_tag
    @ad = Ad.find(params[:id])
  end

  def now
  
    @ads = Ad.includes(:tagged_ads).where('tagged_ads.ad_id=ads.id').order('updated_at DESC').limit(25)

    render "ads/now"
  end

  def map
    @ads = Ad.includes(:tagged_ads).where('tagged_ads.ad_id=ads.id and tagged_ads.lat is not null and tagged_ads.long is not null').order('updated_at DESC').limit(50)

    render "ads/now"
  end

  def newsweek
    #@ads = Ad.order('upload_on DESC').includes({:claims => :claim_details}, :committee)

    @ads = Ad.order('upload_on DESC')

    render "ads/index"
  end

end