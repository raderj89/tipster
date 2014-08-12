class UsersController < ApplicationController

  def new
    @property = Property.find(params[:property_id])
    @user = @property.tenants.build
    @user.property_relations.build
  end

  def create
    @property = Property.find(params[:property_id])
    @user = @property.tenants.build(user_params)

    if @user.save_with_payment(params[:billing_information])
      flash[:success] = "Your account was successfully created!"
      redirect_to @property
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
end
