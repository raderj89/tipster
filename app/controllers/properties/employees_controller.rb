class Properties::EmployeesController < ApplicationController

  before_action :set_property
  before_action :signed_in_employee, except: [:new, :create]
  before_action :correct_employee, except: [:new, :create]

  def new
    @employee = @property.employees.build(invitation_token: params[:invitation_token])
    @employee.invitation_id = (@employee.invitation.id if @employee.invitation)
    @employee.email = (@employee.invitation.recipient_email if @employee.invitation)
    @employee.positions.build(property_id: @property.id)
                       .build_title(title: @employee.invitation_position)
  end

  def create
    @employee = @property.employees.build(employee_params)

    if @employee.save
      flash[:success] = "Your account was successfully created."
      session[:employee_id] = @employee.id
      redirect_to property_employee_setup_payment_path(@property, @employee)
    else
      @employee = @property.employees.build(invitation_token: params[:invitation_token])
      @employee.invitation_id = (@employee.invitation.id if @employee.invitation)
      @employee.email = (@employee.invitation.recipient_email if @employee.invitation)
      @employee.positions.build.build_title(title: @employee.invitation_position)

      # @property_employee.build_title(title: @invitation_position)
      flash[:error] = "There was a problem creating your account."
      render :new
    end
  end

  def setup_payment
    @address = @employee.build_address
  end

  def create_payment
    if @employee.setup_bank_deposit(payment_params)
      flash[:success] = "Your bank account was successfully linked!"
      redirect_to @employee
    else
      flash[:notice] = "There was a problem linking your bank account."
      render :setup_payment
    end
  end

  def create_address
    @address = @employee.build_address(address_params)

    if @address.save
      flash[:success] = "Your mailing address was successfully saved."
      redirect_to @employee
    else
      flash[:notice] = "There was a problem saving your mailing address."
      render :setup_payment
    end
  end

  private

    def employee_params
      params.require(:employee).permit(:invitation_token, :first_name, :last_name, :nickname, :email,
                                       :password, :password_confirmation, positions_attributes:
                                       [:property_id, [title_attributes: [:title]]])
    end

    def set_property
      @property = Property.find(params[:property_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, notice: "We couldn't find that page."
    end

    def signed_in_employee
      unless employee_signed_in?
        redirect_to root_path, notice: "Please sign in."
      end
    end

    def correct_employee
      @employee = Employee.find(params[:employee_id])
      redirect_to current_employee unless current_employee?(@employee)
    end

    def payment_params
      params.require(:bank_information).permit(:account_number, :routing_number)
    end

    def address_params
      params.require(:employee_address).permit(:address_line_1, :address_line_2, :city, :state, :zip)
    end

end