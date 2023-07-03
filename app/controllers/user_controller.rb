class UserController < ApplicationController
  
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if params[:user][:password] == params[:user][:password_confirmation]
      
      if @user.save
        UserMailer.registration_confirmation(@user).deliver
        flash[:notice] = "Please confirm your email address to continue"
        redirect_to '/login'
      else
        flash[:alert] = " OOPS! Try again."
        render 'new'
      end
    else
      flash[:alert] = "Passwords not matching"
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "Profile updated successfully"
      redirect_to user_path
    else
      render 'edit'
    end
  end


  def confirm_email
    user = User.find_by_confirm_token(params[:id])
    if user
      user.email_activate
      flash[:success] = "Welcome to the Bread & Wine! Your email has been confirmed.
      Please sign in to continue."
      redirect_to '/login'
    else
      flash[:error] = "OOPS! User does not exist"
      redirect_to root_url
    end
end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :gender)
  end
end
