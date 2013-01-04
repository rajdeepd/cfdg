desc "Adding Geo location with Events"
task :add_geo_locations_to_events => :environment do
  @events = Event.all
  @events.each do |event|
    @chapter = event.chapter
    chapter_geocode= @chapter.geolocation
    if chapter_geocode.present?
      geocode =event.create_event_geolocation(:latitude => chapter_geocode.latitude, :longitude => chapter_geocode.longitude , :title => chapter_geocode.title)
    end
  end
end





