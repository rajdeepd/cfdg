class OmniauthController < ApplicationController

  def create
    if auth = request.env['omniauth.auth']
      user = User.find_by_email(auth['info']['email'])
      user = User.create_auth_user(auth) unless user
      user.providers.create(:uid => auth['uid'],:provider => auth['provider']) unless user.providers.collect(&:provider).include? auth['provider']
      if user.is_proprietary_user?
        session[:user_id], session[:email], session[:user] = user.id, user.email, {:email => user.email,:verified => true, :name => user.fullname}
        sign_in(user)
        redirect_to(profile_path) && return
      end
      redirect_to users_change_password_path(:reset_password_token => (user.reset_password_token || user.create_token),:set_password => "set_password"), :notice => "Please create your password for proprietary login."

      end
  end

  def auth_failure
    flash[:custom_error] = "Improper authentication"
    redirect_to signin_path
  end

end
