class PasswordsController <  Devise::PasswordsController
  skip_before_filter :require_no_authentication
  before_filter :should_reset_password , :only => [:new]

  def new
    super
  end

  def edit
    super
  end

  def create
    super
  end

  def update
    @user=User.find_by_reset_password_token(params[:user][:reset_password_token])
    #@user.password = params[:password]
    #@user.password_confirmation = params[:password_confirmation]
    if @user.reset_password!(params[:user][:password],params[:user][:password_confirmation])
      session[:user_id] = @user.id
      session[:email] = @user.email
      session[:user] = {:email => @user.email,:verified => true, :name => @user.fullname}
      sign_in_and_redirect(@user)
    else
      render :action => :edit
    end
  end

  def should_reset_password
    redirect_to root_path if @current_user.present?
  end
end
