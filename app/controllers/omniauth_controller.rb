class OmniauthController < ApplicationController

  def create

    if request.env['omniauth.auth'].present?
      auth = request.env['omniauth.auth']
      if !User.find_by_email(auth['info']['email'])
          user = User.create_outh_auth_user(auth)
          redirect_to users_change_password_path(:reset_password_token => user.reset_password_token)
      elsif(user = User.find_by_email(auth['info']['email']))
        if !user.providers.blank?
          if !Provider.find_by_user_id_and_provider(user.id,auth['provider'])
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
          provider = user.providers.new(:uid => auth['uid'],:provider => auth['provider'])
          provider.save!
          token_array =  [('a'..'z'),('A'..'Z'),(0..9)].map{|i| i.to_a}.flatten
          new_reset_token = (0...20).map{ token_array[rand(token_array.length)] }.join
          user.reset_password_token = new_reset_token
          user.save!
          redirect_to users_change_password_path(:reset_password_token => new_reset_token)
        end
      end
    end
  end

end
