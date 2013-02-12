# app/controllers/confirmations_controller.rb
class ConfirmationsController < Devise::PasswordsController
  # Remove the first skip_before_filter (:require_no_authentication) if you
  # don't want to enable logged users to access the confirmation page.
  skip_before_filter :require_no_authentication
  skip_before_filter :authenticate_user!
  def new
#    super
  end



  # GET /resource/confirmation?confirmation_token=abcdef
  def show

    @confirmable = User.find_by_confirmation_token(params[:confirmation_token])
    if @confirmable.present?
      @confirmable.confirm!
      #session[:user_id] = @confirmable.id
      #session[:email] = @confirmable.email
      #session[:user] = {:email => @confirmable.email, :verified => true,:name => @confirmable.fullname}
      #sign_in_and_redirect(@confirmable)
      session[:is_allowed_to_login] = true
      redirect_to sign_up_path(:email => @confirmable.email)
    else
      #redirect_to home_index_path
      redirect_to root_path
    end

  end

  protected

  #def with_unconfirmed_confirmable
  #  @confirmable = User.find_or_initialize_with_error_by(:confirmation_token, params[:confirmation_token])
  #  if !@confirmable.new_record?
  #    @confirmable.only_if_unconfirmed {yield}
  #  end
  #end
  #
  #def do_show
  #  @confirmation_token = params[:confirmation_token]
  #  @requires_password = true
  #  self.resource = @confirmable
  #  render 'devise/confirmations/show' #Change this if you doens't have the views on default path
  #end
  #
  #def do_confirm
  #  @confirmable.confirm!
  #  set_flash_message :notice, :confirmed
  #  sign_in_and_redirect(resource_name, @confirmable)
  #end

#  def only_if_unconfirmed
#    pending_any_confirmation {yield}
#  end

end