require 'will_paginate/array'
class ApplicationController < ActionController::Base
  protect_from_forgery
  include Userstamp 
  before_filter :set_locale, :current_location

  helper_method :current_user , :admin_user
 

  def current_user
    #session[:user_id] = 1
    #@current_user = nil
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
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

  private

  def current_location
      session[:url] = nil
      session[:url] = request.url
  end



end
