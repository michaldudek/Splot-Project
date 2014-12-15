set :state, :prod

server '192.168.0.1', user: 'www-data', roles: :web
set :deploy_to, '/var/www/mdapplication'
set :branch, 'master'