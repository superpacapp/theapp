class ContactController < ActionController::API
  include AbstractController::Layouts
  include ActionController::MimeResponds

  #POST contact
  def create
    @contact = Contact.new(params[:contact])
    @contact.save
    if(@contact.save)
      ContactMailer.superpacapp_contact(@contact).deliver
      render json: @contact
    end
  end

  #GET /contacts
  def index
    @contacts = Contact.all
    render json: @contacts
  end


end