class TaggedAdController < ActionController::API
  include ActionController::MimeResponds

  #GET /tagged ads
  def index
    @tagged_ad = TaggedAd.all

    render "ads/tagged"

  end

  #POST tagged_ad
  def create
    #tag, ad_id, lt, lg
    @tagged_ad = TaggedAd.new

    if !params[:lt].nil?
      @tagged_ad.lat = params[:lt]
    end

    if !params[:lg].nil?
      @tagged_ad.long = params[:lg]
    end

    if !params[:ad_id].nil?
      @tagged_ad.ad_id = params[:ad_id]
    end

    if !params[:tag].nil?
      @tagged_ad.tag = params[:tag]
    end

    @tagged_ad.save

    if(@tagged_ad.save)
      @ad = Ad.find_by_id(params[:ad_id])
      if @tagged_ad.tag == 'love'
        @ad.increment(:love)
        @ad.save
      end
      if @tagged_ad.tag == 'fair'
        @ad.increment(:fair)
        @ad.save
      end
      if @tagged_ad.tag == 'fishy'
        @ad.increment(:fishy)
        @ad.save
      end
      if @tagged_ad.tag == 'fail'
        @ad.increment(:fail)
        @ad.save
      end
      render "ads/tagged_show"
    else
      render "ads/tagged_error"
    end
  end

  def now
    @tagged_ad = TaggedAd.order('updated_at DESC').includes(:ads)

    render "ads/now"
  end


end