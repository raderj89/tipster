class Admin::BaseController < ApplicationController
  layout 'admin'

  private

    def require_admin_signin!
      if current_admin.nil?
        flash[:notice] = "Please sign in."
        redirect_to admin_log_in_url
      end
    end

    helper_method :require_admin_signin!

    def current_admin
      @current_admin ||= Admin.find(session[:admin_id]) if session[:admin_id]
    end

    helper_method :current_admin

end