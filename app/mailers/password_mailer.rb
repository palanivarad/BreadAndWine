class PasswordMailer < ActionMailer::Base

    default :from => "varadharaj.p@chronus.com"

    def reset(user)
        @user = user        
        @token = @user.signed_id(expires_in: 15.minutes)        
        mail(:to => "#{user.name} <#{user.email}>", :subject => "Password Reset Link")
    end
end