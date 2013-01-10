server "chicago.baijii.com", :app, :web, :db, :delayed_job, :primary => true

set :deploy_to, "/home/deployer/deploy/#{application}"
set :rails_env, "staging"
set :rvm_ruby_string, 'ruby-1.9.3-p327-falcon@cfdg'
set :keep_releases, 3
set :branch, "cn-master"

after "bundle:install", "deploy:migrate"
after "deploy:restart", "deploy:cleanup"
