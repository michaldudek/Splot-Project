APP_NAME = "changeme"

Vagrant.require_version ">= 1.7.0", "< 2.0.0"

# Make sure all dependencies are installed
[
    { :name => "vagrant-omnibus", :version => ">= 1.4.1" },
    { :name => "vagrant-berkshelf", :version => ">= 4.0.3" },
    { :name => "vagrant-hostmanager", :version => ">= 1.5.0" },
    { :name => "vagrant-cachier", :version => ">= 1.2.0"}
].each do |plugin|
    Vagrant::Plugin::Manager.instance.installed_specs.any? do |s|
        req = Gem::Requirement.new([plugin[:version]])
        if (not req.satisfied_by?(s.version)) && plugin[:name] == s.name 
            raise "#{plugin[:name]} #{plugin[:version]} is required. Please run `vagrant plugin install #{plugin[:name]}`"
        end
    end

    # Ideally we'd use has_plugin here but there's a bug in 1.7.2 so we need
    # to wait for 1.7.3 to be released
    #if not Vagrant.has_plugin?(plugin[:name], plugin[:version])
        #  raise "#{plugin[:name]} #{plugin[:version]} is required. Please run `vagrant plugin install #{plugin[:name]}`"
    #end
end

Vagrant.configure("2") do |config|
    # install ubuntu
    config.vm.box = "chef/ubuntu-14.04"

    # configure network
    config.vm.hostname = APP_NAME + ".dev"
    config.vm.network "private_network", ip: "192.168.222.10", network: "255.255.0.0"

    # VirtualBox specific config - eg. composer memory problem
    config.vm.provider :virtualbox do |vb, override|
        override.vm.synced_folder ".", "/var/www/" + APP_NAME, :nfs => true
        vb.customize ["modifyvm", :id, "--rtcuseutc", "on"]
        vb.customize ["modifyvm", :id, "--memory", 1024]
        vb.customize ["modifyvm", :id, "--cpus", 1]
    end

    # manage hosts file on the host machine
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true
    config.hostmanager.aliases = [
        "www." + APP_NAME + ".dev"
    ]

    # fixed chef version to be sure that recipes are working
    config.omnibus.chef_version = "latest"

    # enable caching in host machine
    config.cache.auto_detect = true
    config.cache.enable :apt
    config.cache.enable :chef
    config.cache.scope = "machine"

    # chef recipes
    config.berkshelf.enabled = true

    config.vm.provision "chef_solo" do |chef|
        chef.run_list = [
            "recipe[apt]",
            "recipe[chef-hat::base]",
            "recipe[apache2]",
            "recipe[memcached]",
            "recipe[mongodb::10gen_repo]",
            "recipe[mongodb]",
            "recipe[mysql::server]",
            "recipe[nodejs]",
            "recipe[redisio]",
            "recipe[redisio::enable]",
            "recipe[chef-hat::php]",
            "recipe[chef-hat::php-apache2]",
            "recipe[chef-hat::php-composer]",
            "recipe[chef-hat::php-mongo]",
            "recipe[chef-hat::php-redis]",
            "recipe[chef-hat::php-xdebug]",
            "recipe[chef-hat::vhosts]"
        ]
        chef.json = {
            "fqdn" => APP_NAME + ".dev",
            "apache" => {
                # apache should run as vagrant:vagrant in Vagrant with NFS synced dirs, due to dir permissions
                "user" => "vagrant",
                "group" => "vagrant"
            },
            "mysql" => {
                "server_root_password" => "vagrant",
                "server_repl_password" => "vagrant",
                "server_debian_password" => "vagrant"
            },
            "nodejs" => {
                "npm_packages" => [
                    {"name" => "gulp"}
                ]
            },
            "php" => {
                "config" => {
                    "display_errors" => "On",
                    "date.timezone" => "Europe/Warsaw",
                    "opcache" => {
                        "enable" => 0
                    }
                }
            },
            "vhosts" => {
                "100-" + APP_NAME => {
                    "host" => APP_NAME + ".dev",
                    "root_dir" => "/var/www/" + APP_NAME,
                    "log_dir" => "logs",
                    "doc_root" => "web"
                }
            }
        }
    end

    # also run hostmanager after all provisioning has happened
    config.vm.provision :hostmanager

end
