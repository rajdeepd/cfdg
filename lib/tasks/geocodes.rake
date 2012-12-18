desc "Adding Geo location with chapters"
task :add_geo_locations => :environment do
  @chapters = Chapter.incubated_or_active || []
  puts(@chapters.inspect)

end


