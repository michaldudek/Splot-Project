# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    # install debian
    config.vm.box = "debian7.2"
    config.vm.box_url = "https://s3-eu-west-1.amazonaws.com/ffuenf-vagrant-boxes/debian/debian-7.2.0-amd64.box"

    # configure network
    config.vm.hostname = 'mdapplication.dev'
    config.vm.network "private_network", ip: "192.168.200.10", network: "255.255.0.0"

    # VirtualBox specific config - eg. composer memory problem
    config.vm.provider :virtualbox do |vb, override|
        override.vm.synced_folder ".", "/var/www/mdapplication", :nfs => true
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
        "www.mdapplication.dev"
    ]

    # fixed chef version to be sure that recipes are working
    config.omnibus.chef_version = "11.10.0"

    # enable caching in host machine
    config.cache.auto_detect = true
    config.cache.enable :apt
    config.cache.enable :chef
    config.cache.scope = :machine

    # chef recipes
    config.berkshelf.enabled = true

    config.vm.provision "chef_solo" do |chef|
        chef.roles_path = "./config/build/roles"
        chef.add_role "mdapplication_dev"
        chef.json = {
            "apache" => {
                "log_dir" => "/var/log/apache2"
            },
            "node" => {
                "revision" => "v0.10.26",
                "packages" => ["uglify-js"]
            },
            "jolicode-php" => {
                "ext_dir" => "/usr/lib/php5/20100525",
                "config" => {
                    "max_execution_time" => "30",
                    "upload_max_filesize" => "512M",
                    "memory_limit" => "128M",
                    "post_max_size" => "512M",
                    "date.timezone" => "Europe/Warsaw",
                    "html_errors" => "Off"
                },
                "xdebug" => {}
            },
            "redisio" => {
                "mirror" => "http://download.redis.io/releases",
                "version" => "2.8.3"
            },
            "application" => {
                "hosts" => {
                    "app" => {
                        "name" => "mdapplication",
                        "host" => "mdapplication.dev",
                        "vhost" => "mdapplication.host.erb",
                        "root_dir" => "/var/www/mdapplication",
                        "logdir" => "logs",
                        "docroot" => "web"
                    }
                }
            }
        }
    end

    # also run hostmanager after all provisioning has happened
    config.vm.provision :hostmanager

end
