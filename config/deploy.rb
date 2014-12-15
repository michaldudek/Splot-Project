# config valid only for Capistrano 3.1+
lock '>3.1'

set :application, 'mdapplication'
set :scm, :git
set :repo_url, 'git@github.com:michaldudek/splot-project.git'
set :user, "www-data"

set :stages, ["dev", "prod"]
set :default_stage, "dev"

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/parameters.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{web/filestorage}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5


namespace :deploy do
    task :workers_stop do
      on roles(:web) do
        # if it's first deployment then current path doesn't exist
        if !current_path.nil? && !current_path.to_s.empty?
          within current_path do
            execute "cd '#{current_path}'; php app/console workqueue:workers:stop"
          end
        end
      end
    end

    task :workers_start do
      on roles(:web) do
        within release_path do
          execute "cd '#{release_path}'; nohup php app/console workqueue:workers:load > /dev/null 2>&1 &"
          #pty false
        end
      end
    end

    task :node_stop do
        on roles(:web) do
            test "cd '#{current_path}/src_node'; forever stop panel.js"
        end
    end

    task :node_start do
        on roles(:web) do
            execute "cd '#{release_path}/src_node'; forever start panel.js"
        end
    end

    task :composer do
        on roles(:web) do
          # if it's first deployment then current path doesn't exist
          if !current_path.nil? && !current_path.to_s.empty?
            within current_path do
              execute "cd #{current_path}; cp -r vendor #{release_path}"
            end
          end

          within release_path do
            execute "cd '#{release_path}'; composer install --no-interaction --optimize-autoloader"
          end
        end
    end

    task :npm do
        on roles(:web) do
            execute "cd '#{release_path}/src_node'; npm install --production"
        end
    end

    task :assets do
      on roles(:web) do
        within release_path do
          execute "cd '#{release_path}'; php app/console assets:install"
        end
      end
    end

    task :appcache do
      on roles(:web) do
        within release_path do
          execute "cd '#{release_path}'; php app/console cache:clear"
        end
      end
    end

    task :filecache do
      on roles(:web) do
        within release_path do
          execute "cd '#{release_path}'; rm -rf app/cache/*"
        end
      end
    end

    task :entity_indexes do
      on roles(:web) do
        within release_path do
          execute "cd '#{release_path}'; php app/console knit:indexes:ensure"
        end
      end
    end

    #before :publishing, :workers_stop
    before :publishing, :composer
    before :publishing, :appcache
    before :publishing, :filecache
    before :publishing, :assets
    #before :publishing, :npm
    #before :publishing, :node_stop
    #after :publishing, :node_start
    #after :publishing, :workers_start
    after :publishing, :entity_indexes
end