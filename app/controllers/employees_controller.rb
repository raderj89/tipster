class EmployeesController < ApplicationController

  before_action :set_employee, except: [:new, :create, :edit_deposit_method, :update_deposit_method, :update_address]
  before_action :signed_in_employee, except: [:new, :create]
  before_action :correct_employee, except: [:new, :create, :edit_deposit_method, :update_deposit_method, :update_address]

  def new
    @employee = Employee.new(invitation_token: params[:invitation_token])
    if @employee.invitation
      @position = @employee.positions.build
      @position.build_property
    else
      redirect_to root_path, notice: 'You need to be invited to sign up.'
    end
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      sign_in(@employee)
      flash[:success] = "You have successfully created your account!"
      redirect_to_property_invites_or_index(@employee)
    else
      flash[:error] = "There was a problem creating your account."
      render :new
    end
  end

  def show
    @tips = current_employee.tips.paginate(page: params[:page])
  end

  def edit
  end

  def update
    if @employee.update(employee_params)
      flash[:success] = "Your settings have been updated successfully!"
      redirect_to @employee
    else
      flash[:error] = "There was a problem updating your settings."
      render :edit
    end
  end

  def edit_deposit_method
    @address = current_employee.build_address
  end

  def update_deposit_method
    if current_employee.update_bank_deposit(payment_params)
      flash[:success] = "Your deposit method has been updated."
      redirect_to current_employee
    else
      flash[:error] = "There was a problem updating your deposit method"
      @address = current_employee.build_address
      render edit_deposit_method
    end
  end

  def update_address
    @address = current_employee.build_address(address_params)
    if @address.save
      current_employee.deposit_method.update(is_card: false, last_four: nil)
      flash[:success] = "Your deposit method has been updated."
      redirect_to current_employee
    else
      flash[:error] = "There was a problem updating your deposit method."
      render :edit_deposit_method
    end
  end

  private

    def set_employee
      @employee = Employee.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "We couldn't find that page."
      redirect_to root_url
    end

    def signed_in_employee
      unless employee_signed_in?
        redirect_to root_path, notice: "Please sign in."
      end
    end

    def correct_employee
      @employee = Employee.find(params[:id])
      redirect_to current_employee unless current_employee?(@employee)
    end

    def employee_params
      params.require(:employee).permit(:invitation_token, :first_name, :last_name, :nickname,
                                       :email, :is_admin, :password, :password_confirmation,
                                       :avatar, positions_attributes: [:title, :suggested_tip,
                                       property_attributes: [:name,:address, :city, :state, :zip, :picture]])
    end

    def redirect_to_property_invites_or_index(employee)
      if employee.properties.count > 1
        redirect_to @employee
      else
        redirect_to new_property_employee_invitation_path(@employee.properties.first, @employee)
      end
    end

    def payment_params
      params.require(:bank_information).permit(:account_number, :routing_number)
    end

    def address_params
      params.require(:employee_address).permit(:address_line_1, :address_line_2, :city, :state, :zip)
    end
end 