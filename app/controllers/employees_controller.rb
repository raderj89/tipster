class EmployeesController < ApplicationController

  before_action :set_employee
  before_action :signed_in_employee
  before_action :correct_employee

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
end 