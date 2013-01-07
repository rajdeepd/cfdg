

desc "Add country to CFDG"
task :add_country => :environment do
  require 'csv'
  CSV.foreach(Rails.root.join("countries.csv"),{:col_sep =>";"} ) do |row|
    @country = Country.create(:name => row[0])
    puts @country.inspect
  end
end


