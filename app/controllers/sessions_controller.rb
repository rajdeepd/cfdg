class SessionsController <  Devise::SessionsController
  #before_filter :redirect_to_initial_page_if_platform_is_not_configured_yet ,:only => [:new]
  skip_before_filter :require_no_authentication, :only => [ :new, :create ]
  before_filter :is_already_login ,:only => [:new, :create]
  #prepend_before_filter :allow_params_authentication!, :only => :create

  # GET /resource/sign_in
  def new
   logger.info "inside new"
  end

  # POST /resource/sign_in
  def create
    #binding.remote_pry
    logger.info("#######{params.inspect}")
    user = User.find_by_email(params[:user][:email])
    if !user.nil?
      status = user.valid_password?(params[:user][:password]) unless user.nil?
      if status

        session[:user_id] = user.id
        session[:email] = user.email
        session[:user] = {:email => user.email,:verified => true, :name => user.fullname}
        sign_in_and_redirect(user)
      else
        logger.info "inside if status"
        flash.now.alert = "Invalid email or password"
        render "new"
      end
    else
      logger.info("#######{user.inspect}")
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def is_already_login
    if @current_user.present?
      redirect_to root_path
    end
  end

end