class OmniauthCallbacksController < ApplicationController
  def weibo
    handle_callback
  end

  def handle_callback
    auth_data = extract_oauth_data(env['omniauth.auth'])
    
    @user = User.find_for_auth(auth_data)

    if @user.email.nil?
      redirect_to edit_user_path(@user)
    else
      sign_in_and_redirect @user, :event => :authentication
    end
  end

  private
  def extract_oauth_data(data)
    access_data = Hash.new
    provider = data['provider']

    access_data[:provider] = data["provider"]
    access_data[:email] = data['info']['email']
    access_data[:uid] = data["uid"]                
    access_data[:name] = data['info']['name']                
    access_data[:access_token] = data['credentials']['token']
    access_data[:expires_at] = data['credentials']['expires_at']   

    case provider
    when 'qq'
    when 'weibo'
    end

    access_data
  end
end
