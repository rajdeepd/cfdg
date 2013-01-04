

desc "Add cities to CFDG"
task :add_cities => :environment do
  require 'csv'
  CSV.foreach(Rails.root.join("cities.csv"),{:col_sep =>","} ) do |row|
    @city = City.create(:name => row[0],:country_id => row[1], :state_id => row[2])
    puts @city.inspect
  end
end


