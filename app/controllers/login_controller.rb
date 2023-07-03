class LoginController < ApplicationController

  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:login][:email].downcase)

    if user
      if user.authenticate(params[:login][:password])
        if user.email_confirmed
          session[:user_id] = user.id
          current_user
          flash[:notice] = "Logged In Successfully"
          redirect_to root_path
        else
          flash.now[:error] = 'Please activate your account by following the instructions in the account confirmation email you received to proceed'
          render 'new'
        end
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

  def forgot
  end

  def reset
    user = User.find_by(reset_password_token: params[:token])
    if !user.present?
      flash[:alert] = "Link not valid or expired. Try generating a new link."
      redirect_to '/login'
    end
  end

  def sendlink
    if params[:email].blank?
      flash[:alert]  ='Please fill the mail'
      redirect_to '/password/forgot'
    end

    user = User.find_by(email: params[:email]) 

    if user.present?
      user.generate_password_token! #generate pass token
      PasswordMailer.reset(user).deliver
      flash[:notice] = "Please check your mail to reset password"
      redirect_to root_path
    else
      flash[:alert]  ='Please check your mail to reset password'
      redirect_to root_path
    end
  end

  def updatepassword
    if params[:token].present?
      token = params[:token].to_s

      user = User.find_by(reset_password_token: token)

      if user.present? && user.password_token_valid?
        if user.reset_password!(params[:password])
          flash[:notice] = "Password changed successfully"
          redirect_to '/login'
        else
          flash[:alert] = "Internal error. Try again"
          redirect_to root_path
        end
      else
        flash[:alert] = "Link not valid or expired. Try generating a new link."
        redirect_to '/login'
      end
    else
      flash[:alert] = "Invalid Link"
      redirect_to root_path
    end
  end
end
