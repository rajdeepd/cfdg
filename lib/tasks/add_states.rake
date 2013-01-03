

desc "Add states to CFDG"
task :add_state => :environment do
  require 'csv'
  CSV.foreach(Rails.root.join("states.csv"),{:col_sep =>","} ) do |row|
    @state = State.create(:name => row[1],:country_id => row[0])
    puts @state.inspect
  end
end


