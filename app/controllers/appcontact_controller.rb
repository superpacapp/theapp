class AppcontactController < ActionController::API
  include ActionController::MimeResponds

  #GET /appcontacts
  def index
    @appcontact = Appcontact.all

    render json: @appcontact

  end

  #POST contact
  def create
    @appcontact = Appcontact.new(params[:app_contact])
    @appcontact.save
    if(@appcontact.save)
      render json: @appcontact
    end
  end

end