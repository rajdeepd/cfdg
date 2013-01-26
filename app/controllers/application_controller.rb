require 'will_paginate/array'
class ApplicationController < ActionController::Base
  protect_from_forgery
  include Userstamp
  before_filter :set_locale, :current_location
  before_filter :set_cache_buster
  helper_method :admin_user


  def user_required!
    redirect_to root_path() if current_user.nil?
  end

  def user_confirm_required!
    return if current_user.nil?
    unless current_user.is_confirmed?
      redirect_to profile_path, :notice => ["Please confirm you email"]
    end
  end

  def authenticate_member!
    user_required!

    if current_user.email.blank?
      redirect_to settings_path()
    else 
      if !current_user.is_confirmed?
        redirect_to settings_path()
      end
    end
  end

  def after_sign_in_path_for(user)
    if @user.email.nil?
      flash[:notice] = [t("profile.account_not_confirmed")]
      settings_path()
    else
      if flash[:notice].blank?
        root_path()
      else
        profile_path()
      end
    end
  end

  def admin_user
    @admin_user ||= User.find(session[:admin_user_id]) if session[:admin_user_id]
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def admin_required
    if admin_user.nil?
      redirect_to new_admin_session_url
    else
      true
    end
  end

  def default_url_options(options = {})
    options.merge!({ :locale => I18n.locale })
  end

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  private

  def current_location
    session[:url] = nil
    session[:url] = request.url
  end
end
