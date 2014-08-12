class UsersController < ApplicationController

  def dashboard
  end

  def new
    @property = Property.find(params[:property_id])
    @user = @property.tenants.build
    @user.property_relations.build
  end

  def create
    @property = Property.find(params[:property_id])
    @user = @property.tenants.build(user_params)

    if @user.save_with_payment(params[:billing_information])
      session[:user_id] = @user.id
      flash[:success] = "Your account was successfully created!"
      redirect_to @user
    else
      flash[:error] = "There was a problem creating your account."
      render :new
    end
  end

  private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email,
                                   :password, :password_confirmation, :signature,
                                   property_relations_attributes: [:property_id, :unit])
    end

    def signed_in_user
      unless user_signed_in?
        redirect_to root_path, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:user_id])
      redirect_to root_path unless current_user?(@user)
    end

end
