desc "Adding Geo location with chapters"
task :add_geo_locations => :environment do
  @chapters = Chapter.all || []

  markers = []
  @chapters.each do |chapter|
    city = chapter.city_name.blank? ? "" : chapter.city_name + ","
    state = chapter.state_name.blank? ? "" : chapter.state_name + ","
    country = chapter.country_name.blank? ? "" : chapter.country_name
    address=city + state + country
    if(!address.blank?)
      begin
        options = Gmaps4rails.geocode(address)
        #markers << {:lat => options.first[:lat], :lng => options.first[:lng], :title => options.first[:matched_address], :link => chapter_path(chapter)}
        geotag= chapter.create_geolocation(:latitude => options.first[:lat], :longitude => options.first[:lng] , :title => options.first[:matched_address] )
        puts geotag.inspect
      rescue Gmaps4rails::GeocodeStatus
      end
    end
  end



end


