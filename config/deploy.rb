# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'lens-server'
set :repo_url, 'git@github.com:coub/lens-server.git'
set :deploy_to, '/home2/apps/lens-server'

set :rvm_type, :system                     # Defaults to: :auto
set :rvm_map_bins, ['ruby', 'rake', 'bundle']
set :rvm_path, "/usr/local/rvm/bin"
set :rvm_ruby_version, '2.2.2@lens-server'      # Defaults to: 'default'
set :default_env, { rvm_bin_path: '/usr/local/rvm/bin' }

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

desc 'Bundle'
namespace "bundler" do
  task "install" do
    on roles(:app) do
      within release_path do
        execute "bundle", "install"
      end
    end
  end
end

namespace "db" do
  task "migrate" do
    on roles(:app) do
      within release_path do
        execute "rake", "db:migrate"
      end
    end
  end
end


namespace :deploy do
  #after 'deploy:publishing', 'deploy:restart'
  #after :finishing, 'deploy:cleanup'

  #after "deploy:updated", "deploy:bundle"

  after "bundler:install", "db:migrate"
  after "db:migrate", "deploy:restart"

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "sudo sv restart lens"
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end
  
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
