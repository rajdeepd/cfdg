class RegionsController < ApplicationController

  def index
    @countries = Country.all
    @states = State.all
    @cities = City.all

    respond_to do |format|
      format.json { render :json => { countries: @countries, states: @states, cities: @cities }, :status => :ok }
    end
  end
end
