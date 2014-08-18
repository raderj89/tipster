class Api::V1::SessionsController < Api::V1::BaseController

  skip_before_filter :verify_authenticity_token

  def create
    email = params[:session][:email]
    app_user = User.find_by(email: email) || Employee.find_by(email: email)

    return failure unless app_user
    return failure unless app_user.authenticate(params[:session][:password])
     
    # sign_in(app_user)
    
    render status: 200,
      json: {
        success: true,
        info: 'Logged In',
        data: app_user
      }
  end

  def destroy
    session.destroy
    flash[:notice] = "You have logged out successfully."
    redirect_to log_in_path
  end

  def failure
    render status: 200,
      json: {
        success: false,
        info: 'Login failed',
        data: {}
      }
  end
end