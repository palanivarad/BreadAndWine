class UserController < ApplicationController
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if params[:user][:password] == params[:user][:password_confirmation]
      
      if @user.save
        flash[:notice] = "Sign Up Successful"
        redirect_to signup_path
      else
        render 'new'
      end
    else
      flash[:alert] = "Passwords not matching"
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end