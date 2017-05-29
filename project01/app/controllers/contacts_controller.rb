class ContactsController < ApplicationController
  def index
  end

  def list
  end

  def create
  	#persistence not required on this case
  	#@contact = Contact.new(contact_params)
  	#@contact.save
  	redirect_to root_path
  end

  def show
  end

  private
  def contact_params
    params.require(:contact).permit(:name, :email)
  end

end
