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
    @message = Message.new(params[:message])

    
  end

end