class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])

    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:success] = "You have logged in successfully."
      redirect_to user
    else
      flash[:notice] = "Incorrect email or password."
      render :new
    end
  end

  def destroy
    session.destroy
    flash[:notice] = "You have logged out successfully."
    redirect_to user_log_in_path
  end

end