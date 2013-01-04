desc "Add Details"
task :add_detail_to_city => :environment do
  cities = City.all
  cities.each do |i|
    country_name = i.country.name
    state_name = i.state.name
    i.details = i.name + ", " + state_name + ", " + country_name
    puts i.inspect
    i.save
  end
end


