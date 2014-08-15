class Api::V1::SessionsController < Api::V1::BaseController

  def create
    email = params[:session][:email]
    app_user = User.find_by(email: email) || Employee.find_by(email: email)

    if app_user && app_user.authenticate(params[:session][:password])
      sign_in(app_user)
      flash[:success] = "You have logged in successfully."
      redirect_to app_user
    else
      flash[:notice] = "Incorrect email or password."
      render :new
    end
  end

  def destroy
    session.destroy
    flash[:notice] = "You have logged out successfully."
    redirect_to log_in_path
  end
end