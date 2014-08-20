class Api::V1::UsersController < Api::V1::BaseController
  respond_to :json

  skip_before_filter :verify_authenticity_token

  before_action :user_signed_in?
  before_action :correct_user, except: [:create]

  def index
    render json: User.all
  end

  def create
    @user = User.new(user_params)
  
    if @user.save
      sign_in(@user)

      render status: 200,
        json: {
          success: true,
          info: "Registered",
          data: {
            user: @user,
            auth_token: current_user.authentication_token
          }
        }
    else
      render status: :unprocessable_entity,
        json: {
          success: false,
          info: @user.errors,
          data: {}
        }
    end
  end

  def show
    @properties = current_user.properties
    render json: @properties
  end

  private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end

    def correct_user
      unless current_user?(current_user)
        render status: 200,
          json: {
            success: false,
            info: 'Unauthenticated user.',
            data: {}
          }
      end 
    end
end