cookbook_path    [".cookbooks"]
node_path        "config/build/nodes"
role_path        "config/build/roles"
environment_path "config/build/environments"
data_bag_path    "config/build/data_bags"
#encrypted_data_bag_secret "data_bag_key"

knife[:berkshelf_path] = ".cookbooks"
