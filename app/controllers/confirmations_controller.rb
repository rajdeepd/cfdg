class ConfirmationsController < Devise::PasswordsController

  # Remove the first skip_before_filter (:require_no_authentication) if you
  # don't want to enable logged users to access the confirmation page.
  skip_before_filter :require_no_authentication
  skip_before_filter :authenticate_user!

  def new
  end

  def show
    @confirmable = User.find_by_confirmation_token(params[:confirmation_token])
    if @confirmable
      @confirmable.confirm!
      session[:is_allowed_to_login] = true
      redirect_to sign_up_path(:email => @confirmable.email)
    else
      redirect_to home_index_path
    end

  end

end