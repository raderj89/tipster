class Admin::SessionsController < Admin::BaseController
  layout 'admin'

  def new
  end

  def create
    admin = Admin.find_by(email: params[:session][:email])

    if admin && admin.authenticate(params[:session][:password])
      session[:admin_id] = admin.id
      flash[:success] = "You have logged in successfully."
      redirect_to admin_root_url
    else
      flash[:notice] = "Incorrect email or password."
      render :new
    end
  end

  def destroy
    session.destroy
    flash[:notice] = "You have logged out successfully."
    redirect_to admin_log_in_path
  end

end