include_recipe "apache2"

apache_module "ssl" do
    enable true
end

apache_module "rewrite" do
    enable true
end

apache_site 'default-ssl' do
    enable true
end

node[:application][:hosts].each do |name, host|
    # create all necessary dirs for this host
     
    # the root dir
    # sometimes it may not be possible to create it (e.g.if its the same as shared dir on Vagrant)
    directory host[:root_dir] do
        owner "www-data"
        group "www-data"
        mode 0655
        action :create
        not_if do
            Dir.exists?(host[:root_dir])
        end
    end

    # doc root
    docroot = "#{host[:root_dir]}"
    host[:docroot].split('/').each do |dir|
        docroot = "#{docroot}/#{dir}"

        directory docroot do
            owner "www-data"
            group "www-data"
            mode 0655
            action :create
            not_if do
                Dir.exists?(docroot)
            end
        end
    end

    # log dir
    logdir = "#{host[:root_dir]}"
    host[:logdir].split('/').each do |dir|
        logdir = "#{logdir}/#{dir}"

        directory logdir do
            owner "www-data"
            group "www-data"
            mode 0775
            action :create
            not_if do
                Dir.exists?(logdir)
            end
        end
    end

    # and now install appropriate vhosts
    web_app name do
        cookbook "mdapplication"
        template host[:vhost]
        host host[:host]
        docroot docroot
        logdir logdir
        notifies :reload, "service[apache2]"
    end
end