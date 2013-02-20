class OmniauthController < ApplicationController

  def create

    if request.env['omniauth.auth'].present?
      auth = request.env['omniauth.auth']
      logger.info "############# auth hash ############{auth.inspect}"
      if !User.find_by_email(auth['info']['email'])
        #if auth['provider'] == "facebook"
          user = User.create_outh_auth_user(auth)
          redirect_to users_change_password_path(:reset_password_token => user.reset_password_token)
        #elsif auth['provider'] == "google"
        #  user = User.create_google_auth_user(auth)
        #  redirect_to users_change_password_path(:reset_password_token => user.reset_password_token)
        #elsif auth['provider'] == "yahoo"
        #  user = User.create_yahoo_auth_user(auth)
        #  redirect_to users_change_password_path(:reset_password_token => user.reset_password_token)
        #elsif auth['provider'] == "linkedin"
        #  user = User.create_linkedin_auth_user(auth)
        #  redirect_to users_change_password_path(:reset_password_token => user.reset_password_token)
        #end
      elsif(user = User.find_by_email(auth['info']['email']))
        logger.info "############# after finding user ############"
        if !user.providers.blank?
          logger.info "############# if provider not blank ############{user.inspect}"
          if !Provider.find_by_user_id_and_provider(user.id,auth['provider'])
            logger.info "############# creating new provider ############"
            provider = user.providers.new(:uid => auth['uid'],:provider => auth['provider'])
            provider.save!
            session[:user_id] = user.id
            session[:email] = user.email
            session[:user] = {:email => user.email,:verified => true, :name => user.fullname}
            sign_in(user)
            redirect_to(profile_path)
          else
            session[:user_id] = user.id
            session[:email] = user.email
            session[:user] = {:email => user.email,:verified => true, :name => user.fullname}
            sign_in(user)
            redirect_to(profile_path)
          end
        else
          logger.info "############# if provider blank ############"
          provider = user.providers.new(:uid => auth['uid'],:provider => auth['provider'])
          provider.save!
          token_array =  [('a'..'z'),('A'..'Z'),(0..9)].map{|i| i.to_a}.flatten
          new_reset_token = (0...20).map{ token_array[rand(token_array.length)] }.join
          user.reset_password_token = new_reset_token
          user.save!
          logger.info "############# after creating token ############{new_reset_token}"
          redirect_to users_change_password_path(:reset_password_token => new_reset_token)
        end
      end
    end
  end

end
