class PublicController < ApplicationController
  
  def index
  end

  def faq
  end

  def about
  end

  def tos
  end

  def privacy
  end

  def contact
  end

  def request_invitation
    @property = Property.find(params[:property])
    @message = Message.new
  end

  def send_message
    binding.pry
    @message = Message.new(params[:message])

    @property = Property.find(params[:message][:property_id])

    RequestBuilding.request_signup(@message, @property).deliver

    flash[:success] = "Thanks! We have received your message and will be in touch soon!"

    redirect_to root_url
  end

end