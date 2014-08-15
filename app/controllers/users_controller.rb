class UsersController < ApplicationController
  respond_to :js

  before_action :signed_in_user, except: [:new, :create]
  before_action :correct_user, except: [:new, :create]

  def new
    @property = Property.find(params[:property_id])
    @user = @property.tenants.build
    @user.property_relations.build
  end

  def create
    @property = Property.find(params[:property_id])
    @user = @property.tenants.build(user_params)

    if @user.save_with_payment(params[:billing_information])
      sign_in(@user)
      flash[:success] = "Your account was successfully created!"
      redirect_to @user
    else
      flash[:error] = "There was a problem creating your account."
      render :new
    end
  end

  def show
  end

  def remove_property
    @property_relation = current_user.property_relations.find(params[:id])

    if @property_relation.destroy
      flash.now[:notice] = "You have successfully removed the property at #{@property_relation.full_address}"
    else
      flash.now[:error] = "There was a problem removing this property."
    end

    respond_with(@property)
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
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end

end
