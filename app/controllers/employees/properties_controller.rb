class Employees::PropertiesController < ApplicationController
  respond_to :js

  before_action :signed_in_employee
  before_action :correct_employee
  before_action :is_admin?
  before_action :set_property, except: [:update_suggested_tips]

  def show
    @invitation = Invitation.new
  end

  def update_suggested_tips
    @property = Property.find(params[:property_id])
    if @property.property_employees.where(title: params[:title]).update_all(suggested_tip: params[:suggested_tip])
      render nothing: true
    else
      render json: { status: 500, message: "Failure" }
    end
  end

  private

    def signed_in_employee
      unless employee_signed_in?
        redirect_to log_in_path, notice: "Please log in."
      end
    end

    def correct_employee
      @employee = Employee.find(params[:employee_id])
      redirect_to @employee unless current_employee?(@employee)
    end

    def is_admin?
      redirect_to @employee unless @employee.is_admin
    end

    def set_property
      @property = Property.with_employees.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "We couldn't find that page."
      redirect_to @employee
    end

end