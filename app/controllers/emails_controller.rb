class EmailsController < ApplicationController

  def new

  end

  def create
   logger.info "###################{params.inspect}"
   #UserMailer.send_custom_mail(params[:to],params[:subject],params[:body]).deliver
   redirect_to new_email_path, :notice => "Email sent successfully"
  end


end
