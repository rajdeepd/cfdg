class ApplicationController < ActionController::Base
  protect_from_forgery
  include Userstamp 
  before_filter :set_locale

  helper_method :current_user , :admin_user
 

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def admin_user
    @admin_user ||= User.find(session[:admin_user_id]) if session[:admin_user_id]
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options = {})
    options.merge!({ :locale => I18n.locale })
  end
end
