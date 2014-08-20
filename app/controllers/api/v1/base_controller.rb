class Api::V1::BaseController < ActionController::Base
  respond_to :json

  protect_from_forgery with: :null_session

  before_filter :set_cors_headers
  before_filter :cors_preflight

  def set_cors_headers
    headers['Access-Control-Allow-Origin'] = AppConfig.client['origin']
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = '*'
    headers['Access-Control-Max-Age'] = "3628800"
  end

  def cors_preflight
    head(:ok) if request.method == :options
  end

  private

    def sign_in(user)
      session_key = "#{user.class.to_s.downcase}_auth_token".to_sym
      session[session_key] = user.authentication_token

      if session_key == :employee_auth_token && user.is_admin
        user.update(log_in_count: 1)
      end
    end

    helper_method :sign_in

    def current_user
      @current_user ||= User.find_by(authentication_token: session[:user_auth_token]) if session[:user_auth_token]
    end

    helper_method :current_user

    def user_signed_in?
      !current_user.nil?
    end

    helper_method :user_signed_in?

    def current_user?(user)
      current_user == user
    end

    helper_method :current_user?
end