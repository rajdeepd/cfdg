class EmailsController < ApplicationController

  def new

  end

  def create
    logger.info "###################{params.inspect}"
    if UserMailer.send_custom_mail(params[:to],params[:subject],params[:body]).deliver
      flash[:notice] = "Email sent successfully"
      redirect_to new_email_path
    else
      flash[:custom_error] = "Operation failed, please try again"
      redirect_to new_email_path
    end
  end

  def autocomplete_user_email
    logger.info "###################{params.inspect}"
    user = User.where("email like ?","#{params[:term]}%")
    data = user.collect{|i| {:id => i.email, :value => i.email}}
    respond_to do |format|
      format.json{ render :json => data}
    end
  end


end
