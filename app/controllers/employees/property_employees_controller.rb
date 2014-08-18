class Employees::PropertyEmployeesController < ApplicationController
  respond_to :js, :json

  before_action :signed_in_employee
  before_action :correct_employee
  before_action :set_property_employee
  before_action :manages_employee

  def update
    if @property_employee.update(property_employee_params)
      flash.now[:success] = "#{@property_employee.full_name} successfully updated."
      render json: @property_employee, methods: [:title]
    else
      flash.now[:error] = "There was a problem updating #{@property_employee.full_name}."
    end
  end

  def destroy
    if @property_employee.destroy
      flash.now[:success] = "#{@property_employee.full_name} removed from property."
    else
      flash.now[:error] = "There was a problem removing #{@property_employee.full_name} from this property."
    end

    respond_with(@property_employee)
  end

  private

    def signed_in_employee
      unless employee_signed_in?
        redirect_to log_in_path, notice: "Please sign in."
      end
    end

    def correct_employee
      @employee = Employee.find(params[:employee_id])
      redirect_to @employee unless current_employee?(@employee)
    end

    def set_property_employee
      @property_employee = PropertyEmployee.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        flash[:notice] = "Something went wrong."
        redirect_to @employee
    end

    def manages_employee
      @property_employee = nil unless @employee.manages?(@property_employee)
    end

    def property_employee_params
      params.require(:property_employee).permit(:title)
    end
end