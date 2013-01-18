require 'bundler/capistrano'
require "delayed/recipes"  # Load delayed_job:stop, start, restart
require 'capistrano_colors'

set :use_sudo, false
set :rvm_type, :system
require "rvm/capistrano" # Load RVM's capistrano plugin.

set :stages, %w(staging production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

set :application, "vmware-cfdg"

# ssh to the deploy server
default_run_options[:pty] = true

# setup scm:
set :repository,  "git@bitbucket.org:larryzhao/vmware-cfdg.git"
set :deploy_via, :remote_cache
set :scm_username, "larryzhao"
set :scm, :git
set :scm_verbose, "true"
set :user, 'deployer'
set :runner, 'deployer'
ssh_options[:forward_agent] = true

# set path
set(:releases_path)     { File.join(deploy_to, version_dir) }
set(:shared_path)       { File.join(deploy_to, shared_dir) }
set(:current_path)      { File.join(deploy_to, current_dir) }
set(:release_path)      { File.join(releases_path, release_name) }


# set gems
set :bundle_without, [:development,:test]

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{current_release}"
  end
end

namespace :deploy do
  desc "Zero-downtime restart of Unicorn"
  task :restart, :except => { :no_release => true } do
    #run "cd #{shared_path}/pids && kill -s USR2 `cat unicorn.pid`"
    run "cd #{release_path} && bundle exec unicorn_rails -E #{rails_env} -c #{release_path}/config/unicorn.rb -D"
  end

  desc "Start unicorn"
  task :start, :except => { :no_release => true } do
    run "cd #{current_path} && bundle exec unicorn_rails -E #{rails_env} -c config/unicorn.rb -D"
  end

  desc "Stop unicorn"
  task :stop, :except => { :no_release => true } do
    run "cd #{shared_path}/pids && kill -s QUIT `cat unicorn.pid`"
  end
end
