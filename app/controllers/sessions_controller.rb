class SessionsController <  Devise::SessionsController
  #before_filter :redirect_to_initial_page_if_platform_is_not_configured_yet ,:only => [:new]
  skip_before_filter :require_no_authentication, :only => [ :new, :create ]
  before_filter :is_already_login ,:only => [:new, :create]
  #before_filter :admin_cant_sign_in ,:only => [:create]
  #prepend_before_filter :allow_params_authentication!, :only => :create

  # GET /resource/sign_in
  def new
    logger.info "inside new"
  end

  # POST /resource/sign_in
  def create
    #logger.info("#######{params.inspect}")
    user = User.find_by_email(params[:user][:email])
    if !user.nil?
      status = user.valid_password?(params[:user][:password]) unless user.nil?
      if status && !user.admin?
        if(user.confirmed?)
          session[:user_id] = user.id
          session[:email] = user.email
          session[:user] = {:email => user.email,:verified => true, :name => user.fullname}
          sign_in(user)
          #redirect_to(dashboard_user_path(user))
          redirect_to(profile_path)
        else
          flash.now.alert = "You need to confirm your account"
          #redirect_to(root_path)
          render "new"
        end
      elsif status && user.admin?
        session[:user_id] = user.id
        redirect_to admin_chapters_url, :notice => "Logged in!"
      else
        logger.info "inside if status"
        #flash.now.alert = "Invalid email or password"
        flash.now[:custom_error] = "Invalid email or password"
        render "new"
      end
    else
      logger.info("#######{user.inspect}")
      flash.now[:custom_error] = "Invalid email or password"
      render "new"
    end
  end

  def logout
      session[:user_id] = nil
      #redirect_to new_admin_session_url, :notice => "Logged out!"
      redirect_to root_path, :notice => "Logged out!"
  end

  def is_already_login
    if @current_user.present?
      redirect_to root_path
    end
  end

  def admin_cant_sign_in
    user = User.find_by_email(params[:user][:email])
    if user.present? and user.admin == true
      redirect_to "/admin"
    end
  end

end