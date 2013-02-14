class Admin::SessionsController < ApplicationController
  layout 'admin'
  def new
    if !session[:admin_user_id].blank?
      redirect_to admin_chapters_url
    else
      redirect_to root_path
    end
  end

  def create
    user = User.find(:first, :conditions => ["email = ?", params[:email]])
    if !user.nil?
      status = user.valid_password?(params[:password]) unless user.nil?
      if status && user.admin?
        session[:admin_user_id] = user.id
        redirect_to admin_chapters_url, :notice => "Logged in!"
      else
       flash.now.alert = "Invalid email or password"
       render "new"
      end
    else
       flash.now.alert = "Invalid email or password"
       render "new"
    end      
  end

  def destroy
    session[:admin_user_id] = nil
    #redirect_to new_admin_session_url, :notice => "Logged out!"
    redirect_to root_path, :notice => "Logged out!"
  end
  
end
