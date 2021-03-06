class HomeController < ApplicationController
  before_filter :announcements , :only => [:index, :wiki]
  before_filter :chapters , :only => [:index, :directory, :about]

  layout "application"

  def index   
  end

  def directory  
  end

  def about
  end
  
  def wiki
    respond_to do |format|
      format.html {render :layout => "wiki_page"}      
    end
  end

  protected

  def get_markers
  	markers = []    
  	@chapters.each do |chapter|  
      address = get_address(chapter)    
      if(!address.blank?)
        begin
  		    options = Gmaps4rails.geocode(address)
          markers << {:lat => options.first[:lat], :lng => options.first[:lng], :title => options.first[:matched_address], :link => chapter_path(chapter)}
          rescue Gmaps4rails::GeocodeStatus
        end
     end
  	end
  	markers
  end

  def get_address(chapter)    
    city = chapter.city_name.blank? ? "" : chapter.city_name + "," 
    state = chapter.state_name.blank? ? "" : chapter.state_name + ","     
    country = chapter.country_name.blank? ? "" : chapter.country_name
    city + state + country
  end

  def announcements
    @announcements = Announcement.order("created_at DESC")
  end

  def chapters
    @chapters = Chapter.incubated_or_active || []
  	@markers = get_markers.to_json 
  end
end
