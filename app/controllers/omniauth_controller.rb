class OmniauthController < ApplicationController

  def create
    logger.info("#######{request.env['omniauth.auth'].inspect}")
    redirect_to root_path
  end

end
