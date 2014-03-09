log_level                :info
log_location             STDOUT
node_name                'root'
client_key               '/root/chef-repo/.chef/root.pem'
validation_client_name   'chef-validator'
validation_key           '/etc/chef-server/chef-validator.pem'
chef_server_url          'https://saasmaster.saasservicer.h2.internal.cloudapp.net:443'
syntax_check_cache_path  '/root/chef-repo/.chef/syntax_check_cache'
cookbook_path [ '/root/chef-repo/cookbooks' ]
knife[:azure_publish_settings_file] = "myazure.publishsettings"
