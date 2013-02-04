desc "Delay job"
task :starting_delay_job => :environment do
  `script/delayed_job start RAILS_ENV= production`
end


