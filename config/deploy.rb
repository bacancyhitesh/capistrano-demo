# config valid only for current version of Capistrano
lock "3.9.0"

set :application, "CapistranoDemo"
set :repo_url, "git@github.com:bacancyhitesh/capistrano-demo.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Application environment
set :stage, :production

# Deployer user
set :user, "hitesh"

set :home, '/home/hitesh'
set :tmp_dir, "#{fetch(:home)}/tmp"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true

# Allow SUDO permissions
set :use_sudo, true

# I don't know just copy pasted
set :deploy_via, :remote_cache

# Ruby Version
set :rvm_type, :user
set :rvm_ruby_version, '2.3.3'

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5


set :linked_files, %w{config/database.yml config/secrets.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle }
set :ssh_options, { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }

namespace :deploy do

  desc 'Restart application'
  task :restart do
  	on roles(:app), in: :sequence, wait: 5 do
    	execute :touch, release_path.join('tmp/restart.txt')
  	end
  end

  # after :deploy, 'deploy:setup_react'
  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end

namespace :deploy do

  after :restart, :clear_cache do
  	on roles(:web), in: :groups, limit: 3, wait: 10 do
    	# Here we can do anything such as:
    	# within release_path do
    	#   execute :rake, 'cache:clear'
    	# end
  	end
  end

end