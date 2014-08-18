class EmployeesController < ApplicationController

  before_action :set_employee, except: [:new, :create]
  before_action :signed_in_employee, except: [:new, :create]
  before_action :correct_employee, except: [:new, :create]

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
                                       positions_attributes: [:title, :suggested_tip],
                                       property_attributes: [:name,:address, :city, :state, :zip, :picture])
    end

    def redirect_to_property_invites_or_index(employee)
      if employee.properties.count > 1
        redirect_to @employee
      else
        redirect_to new_property_employee_invitation_path(@employee.properties.first, @employee)
      end
    end
end 