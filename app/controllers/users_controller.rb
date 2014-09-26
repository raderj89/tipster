class UsersController < ApplicationController
  respond_to :js, :html

  before_action :set_property, only: [:new, :create]
  before_action :signed_in_user, except: [:new, :create]
  before_action :correct_user, except: [:new, :create, :remove_property, :edit_payment_method, :update_payment_method]

  def new
    if @property.is_managed
      @user = @property.tenants.build
      @user.property_relations.build
    else
      redirect_to request_invitation_path(property: @property)
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save_with_payment(params[:billing_information])
      sign_in(@user)
      flash[:success] = "Your account was successfully created!"
      redirect_to @user
    else
      flash[:error] = "There was a problem creating your account."
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash.now[:success] = "You've successfully updated your settings."
    else
      flash.now[:error] = "There was a problem updating your information."
    end

    respond_with(@user) do |format|
      format.html { redirect_to @user }
    end
  end

  def show
    @transactions = current_user.transactions.paginate(page: params[:page])
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

  def edit_payment_method
  end

  def update_payment_method
    if current_user.update_or_create_card(params[:billing_information])
      flash[:success] = "Your payment method has been successfully updated."
      redirect_to current_user
    else
      flash[:error] = "There was a problem updating your payment method."
      render :edit_payment_method
    end
  end

  private

    def set_property
      @property = Property.find(params[:property_id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Please select a property from the dropdown menu."
      redirect_to root_path
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :avatar,
                                   :password, :password_confirmation, :signature,
                                   property_relations_attributes: [:property_id, :unit])
    end
end
