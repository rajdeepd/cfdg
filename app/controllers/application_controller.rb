require 'will_paginate/array'
class ApplicationController < ActionController::Base
  protect_from_forgery
  include Userstamp
  before_filter :set_locale, :current_location
  before_filter :set_cache_buster

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

  def set_cache_buster

    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def get_country(request)
    country= request.location.country
    #country = "India" if country == "Reserved" #doing this coz in local(dev environment)  IP is 127.0.0.1 for this country is reserved
    logger.info "@@@@@@@@@@@@@@@@@@@@@@@ request.location file @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#{request.location.inspect}"
    logger.info "####################### country in application.rb file ################################{country.inspect}"
  end


  private

  def current_location
    session[:url] = nil
    session[:url] = request.url
  end



end
