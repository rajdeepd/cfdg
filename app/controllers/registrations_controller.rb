class RegistrationsController  < Devise::RegistrationsController
  before_filter :authenticate_user!, :only => :token
  before_filter :is_already_login ,:only => [:new, :create]
  skip_before_filter :require_no_authentication, :only => [ :new, :create ]
  def new
    super
  end


  def create
    @user = User.new(params[:user])
    #@user.fullname = "#{params[:user][:first_name]} #{params[:user][:last_name]}"
    if @user.save
      #session[:user], session[:user_id], session[:user_name] = {:name => @user.fullname, :email => @user.email, :id => @user.id}, @user.id, @user.fullname
      #@registered = true
      flash[:notice] = "Please check your email and confirm your account"
      #redirect_to home_index_path
      redirect_to root_path
    else
      flash.now[:custom_error] = "Invalid email or password"
      render :action => :new
    end
  end

  def update
    super
  end

  def is_already_login
    if @current_user.present?
      redirect_to root_path
    end
  end

end
