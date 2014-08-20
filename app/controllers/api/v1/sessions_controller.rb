class Api::V1::SessionsController < Api::V1::BaseController

  skip_before_filter :verify_authenticity_token

  def create
    email = params[:session][:email]
    app_user = User.find_by(email: email) || Employee.find_by(email: email)

    return failure unless app_user
    return failure unless app_user.authenticate(params[:session][:password])
     
    sign_in(app_user)
    
    render status: 200,
      json: {
        success: true,
        info: 'Logged In',
        data: { auth_token: app_user.authentication_token }
      }
  end

  def get_current_user
    if user_signed_in?
      render status: 200,
        json: {
          success: true,
          info: "Current user",
          data: {
            auth_token: current_user.authentication_token,
            email: current_user.email,
            full_name: current_user.full_name
          }
        }
    else
      render status: 401,
        json: {
          success: true,
          info: "",
          data: {}
        }
     end
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