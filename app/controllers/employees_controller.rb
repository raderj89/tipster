class EmployeesController < ApplicationController

  before_action :set_property
  before_action :signed_in_employee
  before_action :correct_employee

  def new
  end

  def setup_payment
  end

  def create_payment
    if @employee.setup_bank_deposit(payment_params)
      flash[:success] = "Your bank account was successfully linked!"
      redirect_to @property
    else
      flash[:notice] = "There was a problem linking your bank account."
      render :setup_payment
    end 
  end

  private

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
      redirect_to root_path unless current_employee?(@employee)
    end

    def payment_params
      params.require(:bank_information).permit(:account_number, :routing_number)
    end
end 