class ClaimController < ApplicationController
  include ActionController::MimeResponds

  #GET /claims
  def index

    @claims = Claim.all(:include => :claim_details)

    render "claims/index"

  end

  #GET /ads/1
  def show

    @claim = Claim.find_by_id(params[:id], :include => :claim_details)

    render "claims/show"
  end

  def newsweek
    @claims = Claim.all(:include => :claim_details)

    render "claims/newsweek"
  end

end
