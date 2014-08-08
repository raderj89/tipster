class PropertyEmployeesController < ApplicationController

  before_action :set_property

  def new
    @property_employee = @property.property_employees.build
    @employee = Employee.new(invitation_token: params[:invitation_token])

    @property_employee.build_employee(invitation_id: (@employee.invitation.id if @employee.invitation),
                                      email: (@employee.invitation.recipient_email if @employee.invitation))
    @property_employee.build_title(title: @invitation_position)
  end

  def create
    @property_employee = @property.property_employees.build(property_employee_params)
    @employee = Employee.new(invitation_token: params[:invitation_token])

    if @property_employee.save
      flash[:success] = "Your account was successfully created."
      redirect_to property_employee_setup_payment_path(@property, current_employee)
    else
      @property_employee.build_employee(invitation_id: (@employee.invitation.id if @employee.invitation),
                                        email: (@employee.invitation.recipient_email if @employee.invitation))
      @property_employee.build_title(title: @invitation_position)
      flash[:error] = "There was a problem creating your account."
      render :new
    end
  end

  private

    def set_property
      @property = Property.find(params[:property_id])
    end

    def property_employee_params
      params.require(:property_employee).permit(title_attributes: [:title], employee_attributes: [:invitation_token, :first_name,
                                                :last_name, :nickname, :email, :password, :password_confirmation])
    end

end