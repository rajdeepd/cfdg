class EducationsController < ApplicationController
  respond_to :json

  def colleges
    if params[:state_id]
      state = State.where(:id => params[:state_id]).first

      if state
        @colleges = state.colleges
      else
        @colleges = []
      end
    else
      @colleges = College.all
    end 

    respond_with @colleges
  end
  
  def institutions
    if params[:college_id]
      college = College.where(:id => params[:college_id]).first
      
      if college
        @institutions = college.institutions
      else
        @institutions = []
      end
    else
     @institutions = Institution.all 
    end

    respond_with @institutions
  end
end
