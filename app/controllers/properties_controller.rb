class PropertiesController < ApplicationController
  
  before_action :set_property, only: [:show]

  def index
    @properties = Property.search(params[:term], fields: [:address, :full_address])
    render json: @properties, only: [:id, :full_address, :picture], methods: [:picture_thumb]
  end

  def new
    @property = Property.new
    @employee = Employee.new(invitation_token: params[:invitation_token])
    if @employee.invitation
      # If property attributes were added to the invitation, include those
      @property.name = @employee.invitation.property_name
      @property.address = @employee.invitation.property_address
      @property.city = @employee.invitation.property_city
      @property.state = @employee.invitation.property_state
      @property.zip = @employee.invitation.property_zip
      
      @property_employee = @property.property_employees.build
      
      # Build related objects
      @property_employee.build_employee(invitation_id: @employee.invitation.id,
                                        email: (@employee.invitation.recipient_email if @employee.invitation),
                                        is_admin: (@employee.invitation_is_admin if @employee.invitation ) )
      @property_employee.build_title
    else
      redirect_to root_path, notice: 'You need to be invited to sign up.'
    end
  end

  def create
    @property = Property.new(property_params)

    if @property.save
      @employee = @property.employees.first
      flash[:success] = "Your account was successfully created!"
      session[:employee_id] = @employee.id
      @employee.update_attribute(:log_in_count, 1)
      redirect_to new_property_employee_invitation_path(@property, @employee)
    else
      # Re-set the @employee instance with its invitation token
      @employee = Employee.new(invitation_token: params[:property][:property_employees_attributes]["0"][:employee_attributes][:invitation_token])
      @property_employee = @property.property_employees.build
      
      flash[:error] = "There was a problem creating your account."
      render :new
    end
  end

  def show
  end

  private

    def set_property
      @property = Property.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, notice: "We couldn't find that page."
    end

    def property_params
      params.require(:property).permit(:name, :address, :city, :state, :zip, :picture,
                                       property_employees_attributes: [title_attributes: [:title], employee_attributes: [:invitation_token, :first_name,
                                       :last_name, :nickname, :email, :is_admin, :password, :password_confirmation]])
    end


end