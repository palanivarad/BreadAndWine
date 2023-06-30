class LoginController < ApplicationController

  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:login][:email].downcase)

    if user
      if user.authenticate(params[:login][:password])
        session[:user_id] = user.id
        current_user
        flash[:notice] = "Logged In Successfully"
        redirect_to root_path
      else
        flash.now[:alert] = "Invalid Password"
        render "new"
      end
    else
      flash.now[:alert] = "Invalid User"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Logged Out Successfully"
    redirect_to root_path
  end
end
