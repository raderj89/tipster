class PropertiesController < ApplicationController

  def new
    @property = Property.new
    @employee = Employee.new(invitation_token: params[:invitation_token])
    @property.name = @employee.invitation.property_name
    @property.address = @employee.invitation.property_address
    @property.city = @employee.invitation.property_city
    @property.state = @employee.invitation.property_state
    @property.zip = @employee.invitation.property_zip

    binding.pry

    @property_employee = @property.property_employees.build
    
    @property_employee.build_employee(invitation_id: @employee.invitation.id,
                                      email: (@employee.invitation.recipient_email if @employee.invitation) )
    @property_employee.build_title
  end

  def create
    @property = Property.new(property_params)

    if @property.save
      flash[:success] = "Your account was successfully created!"
      redirect_to new_property_employee_path(@property)
    else
      # Re-set the @employee instance with its invitation token
      @employee = Employee.new(invitation_token: params[:property][:property_employees_attributes]["0"][:employee_attributes][:invitation_token])
      @property_employee = @property.property_employees.build
      
      flash[:error] = "There was a problem creating your account."
      render :new
    end
  end

  private

    def property_params
      params.require(:property).permit(:name, :address, :city, :state, :zip, :picture,
                                       property_employees_attributes: [title_attributes: [:title], employee_attributes: [:invitation_token, :first_name,
                                       :last_name, :nickname, :email, :password, :password_confirmation]])
    end

end