class EmailsController < ApplicationController

  def new

  end

  def create
   logger.info "###################{params.inspect}"
  end


end
