class Api::V1::UsersController < Api::V1::BaseController

  def index
    render json: User.all
  end

  def show
    @properties = current_user.properties
    render json: @properties
  end
end