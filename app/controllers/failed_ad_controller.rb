class FailedAdController < ActionController::API
  include ActionController::MimeResponds

  #GET /appcontacts
  def index
    @failed_ads = FailedAd.all

    render "ads/failed_ad_index"

  end

  #POST failed_ad
  def create
    #s, c, lt, lg, cmt
    @failed_ad = FailedAd.new

    if !params[:lt].nil?
      @failed_ad.lat = params[:lt]
    end

    if !params[:lg].nil?
      @failed_ad.long = params[:lg]
    end

    if !params[:s].nil?
      @failed_ad.suppopp = params[:s]
    end

    if !params[:c].nil?
      @failed_ad.candidate = params[:c]
    end

    if !params[:cmt].nil?
      @failed_ad.comment = params[:cmt]
    end

    @failed_ad.save

    if(@failed_ad.save)
      ContactMailer.failed_ad(@failed_ad).deliver
      render "ads/failed_ad_success"
    else
      render "ads/failed_ad_error"
    end
  end

end