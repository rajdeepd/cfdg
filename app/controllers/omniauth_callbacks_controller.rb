class OmniauthCallbacksController < ApplicationController
  def weibo
    handle_callback
  end

  def qq_connect
    handle_callback
  end

  def handle_callback
    logger.info("*** oauth data *****")
    logger.info(env['omniauth.auth'].inspect)
    logger.info("*" * 10)

    auth_data = extract_oauth_data(env['omniauth.auth'])
    
    @user = User.find_for_auth(auth_data)

    sign_in_and_redirect @user, :event => :authentication
  end

  def failure
    redirect_to root_path, :notice => "error"
  end

  private
  def extract_oauth_data(data)
    access_data = Hash.new
    provider = data['provider']

    access_data[:provider] = data["provider"]
    access_data[:uid] = data["uid"]                
    access_data[:email] = data['info']['email']
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
