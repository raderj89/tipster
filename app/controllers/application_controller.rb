class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

    # Employee users
    def current_employee
      @current_employee ||= Employee.find(session[:employee_id]) if session[:employee_id]
    end

    helper_method :current_employee

    def employee_signed_in?
      !current_employee.nil?
    end

    helper_method :employee_signed_in?

    def current_employee?(employee)
      employee == current_employee
    end

    helper_method :current_employee?
    
end
