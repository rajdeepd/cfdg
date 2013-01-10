class RegistrationsController  < Devise::RegistrationsController 
  before_filter :authenticate_user!, :only => :token

  def new
    @countries = Country.all
    @states = @countries.first.states
    @cities = @states.first.cities

    @user = session[:new_user]
  end


  def create
    @user = User.new(params[:user])
    @user.fullname = "#{params[:user][:first_name]} #{params[:user][:last_name]}"
    if @user.save
      session[:user], session[:user_id], session[:user_name] = {:name => @user.fullname, :email => @user.email, :id => @user.id}, @user.id, @user.fullname
      @registered = true
      flash[:notice] = "You have signed up successfully. "     
      redirect_to root_url
    else
      render :action => :new
    end
  end

  def update
    super
  end
end
