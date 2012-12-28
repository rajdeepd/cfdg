class RegistrationsController  < Devise::RegistrationsController 
    before_filter :authenticate_user!, :only => :token
    #before_filter :login_required, :except=>[:new, :create]

    def new
      super      
    end


  def create
    @user = User.new(params[:user])
    #@user.fullname = "#{params[:user][:first_name]} #{params[:user][:last_name]}"
    if @user.save
      #session[:user], session[:user_id], session[:user_name] = {:name => @user.fullname, :email => @user.email, :id => @user.id}, @user.id, @user.fullname
      #@registered = true
      flash[:notice] = "You have signed up successfully. "
      redirect_to home_index_path
    else
      render :action => :new
    end
  end

  def update
    super
  end
  

end
