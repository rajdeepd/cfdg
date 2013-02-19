class OmniauthController < ApplicationController

  def create

    if request.env['omniauth.auth'].present?
      auth = request.env['omniauth.auth']
      logger.info "############# auth hash ############{auth.inspect}"
      if !User.find_by_email(auth['info']['email'])
        if auth['provider'] == "facebook"
          user = User.create_fb_auth_user(auth)
          redirect_to users_change_password_path(:reset_password_token => user.reset_password_token)
        elsif auth['provider'] == "google"
          user = User.create_google_auth_user(auth)
          redirect_to users_change_password_path(:reset_password_token => user.reset_password_token)
        end
      elsif(user = User.find_by_email(auth['info']['email']))
        if user.providers
          if !Provider.find_by_user_id_and_provider(user.id,auth['provider'])
            provider = user.providers.new(:uid => auth['uid'],:provider => auth['provider'])
            provider.save!
          end
        else
          provider = user.providers.new(:uid => auth['uid'],:provider => auth['provider'])
          provider.save!
        end
        session[:user_id] = user.id
        session[:email] = user.email
        session[:user] = {:email => user.email,:verified => true, :name => user.fullname}
        sign_in(user)
        redirect_to(profile_path)
        #redirect_to root_path, :notice => "user already present!"
      end
    end
  end

end
