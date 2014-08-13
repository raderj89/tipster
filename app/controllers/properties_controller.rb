class PropertiesController < ApplicationController
  
  before_action :set_property, only: [:show]

  def index
    @properties = Property.search(params[:term], fields: [:address, :full_address])
    render json: @properties, only: [:id, :full_address, :picture], methods: [:picture_thumb]
  end

  # def new
  #   @employee = Employee.new(invitation_token: params[:invitation_token])
  #   if @employee.invitation
  #     @property = Property.new
  #     @property_employee = @property.property_employees.build
  #     @property_employee.build_employee
  #   else
  #     redirect_to root_path, notice: 'You need to be invited to sign up.'
  #   end
  # end

  # def create
  #   @property = Property.new(property_params)

  #   if @property.save
  #     @employee = @property.employees.first
  #     sign_in(@employee)
  #     flash[:success] = "Your account was successfully created!"
  #     redirect_to new_property_employee_invitation_path(@property, @employee)
  #   else
  #     # Re-set the @employee instance with its invitation token
  #     @employee = Employee.new(invitation_token: params[:property][:property_employees_attributes]["0"][:employee_attributes][:invitation_token])
  #     @property_employee = @property.property_employees.build
      
  #     flash[:error] = "There was a problem creating your account."
  #     render :new
  #   end
  # end

  def show
  end

  private

    def set_property
      @property = Property.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, notice: "We couldn't find that page."
    end

    # def property_params
    #   params.require(:property).permit(:name, :address, :city, :state, :zip, :picture,
    #                                    property_employees_attributes: [title_attributes: [:title], employee_attributes: [:invitation_token, :first_name,
    #                                    :last_name, :nickname, :email, :is_admin, :password, :password_confirmation]])
    # end


end