class FederatedController < ApplicationController
  require 'uri'
  require 'restclient' # https://github.com/archiloque/rest-client
  require 'net/http'

  def verify_user
    api_params = {'requestUri' => request.url, 'postBody' => request.post? ? request.raw_post : URI.parse(request.url).query }
    verify_user_details(FEDERATED_BASE_URL, api_params)
    render :layout => false
  end

  def verify_user_details(api_url, api_params)
    return(@email = nil) if params['openid.mode'] == 'cancel'
    @res = get_assertion(api_url, api_params)
    unless @res.nil?
      @email = @res["verifiedEmail"] || @res["email"]
      if !params['rp_input_email'].blank? and @email != params['rp_input_email']
        @mismatch = true
        @email = nil
      end
      verify_registration_status unless @email.nil?
    end
  end

  def logout
    reset_session
    cookies.delete(:user_id)
    redirect_to root_path, :notice => "Logged out!"
  end

  def verify_registration_status
    @user = User.find_by_email(@email)
    if @user.nil? or @user.blank?
      @user = User.create!(:email => @email,:password => "cloudfoundry", :password_confirmation => "cloudfoundry", :fullname => @res["fullName"])
      session[:email] = @user.email
      @registered = false
    else
      session[:user_id] = @user.id
      session[:email] = @user.email
      session[:user] = {:email => @user.email, :verified => true, :name => @user.fullname}
      @registered = true
    end
  end

  def user_status
    status = User.find_by_email(params[:email])
    if status
      @registered = session[:legacy] = true
    else
      @registered = false
      session[:email] = params[:email]
    end
    render :json => {'registered' => @registered}
  end

  def login
    user = User.find(:first, :conditions => ["email = ?", params[:email]])
    status = user.valid_password?(params[:password]) unless user.nil?
    if status
      session[:user_id] = user.id
      session[:user],session[:user_type],session[:user_name], @status = {:name => user.fullname, :email => params[:email], :id => session[:user_id], :from => 'Normal'},user.fullname,user.fullname, 'OK'
    else
      @status = 'passwordError'
    end
    render :json => {'status' => @status}
  end

  protected

  def get_assertion(url, params)
    begin
      api_response = RestClient.post(url, params.to_json, :content_type => :json )
      verified_assertion = JSON.parse(api_response)
      puts verified_assertion.inspect
      if verified_assertion.include? "verifiedEmail" or verified_assertion.include? "email"
        return verified_assertion
      else
        raise StandardError
      end
    rescue StandardError => error
      return nil
    end
  end
end
