class Admin::DashboardController < Admin::BaseController
  before_action :require_admin_signin!

  def index
  end

end