class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

    # Tenants
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    helper_method :current_user

    def user_signed_in?
      !current_user.nil?
    end

    helper_method :user_signed_in?

    def current_user?(user)
      user == current_user
    end

    helper_method :current_user?

    # Employee users
    def current_employee
      @current_employee ||= Employee.find(session[:employee_id]) if session[:employee_id]
    end

    helper_method :current_employee

    def sign_in(user)
      session_key = "#{user.class.to_s.downcase}_id".to_sym
      session[session_key] = user.id
      if session_key == :employee_id && user.is_admin
        user.update(log_in_count: 1)
      end
    end

    def employee_signed_in?
      !current_employee.nil?
    end

    helper_method :employee_signed_in?

    def current_employee?(employee)
      employee == current_employee
    end

    helper_method :current_employee?
    
end
