#
# Cookbook Name:: init_hosts
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

require 'chef/shell_out'

# Cluster name for this node
hostname_elements = (node[:hostname]).split("-")
node.set['cluster_name'] = hostname_elements[1]
log "Cluster Name: #{node['cluster_name']}"


##
## Setup /etc/hosts
##
# Backup original /etc/hosts
backup_hosts = Mixlib::ShellOut.new("cp /etc/hosts /etc/hosts.original")
backup_hosts.run_command

log "File /etc/hosts backed up"

#Search all nodes within Hadoop Cluster
#nodes = search(:node, "role:#{node['hadoop_cluster_role']}")
nodes = search(:node, "name:*#{node['cluster_name']}*")

# Update /etc/hosts
template "/etc/hosts" do
  source "hosts.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :hosts => nodes.sort_by { |h| h[:hostname] }
  )
end

##
## Setup shared SSH keys
##

# String for cluster public keys
authorized_keys = ''

# Search all nodes within the cluster
# nodes = search(:node, "role:#{node['hadoop_cluster_role']}")
nodes = search(:node, "name:*#{node['cluster_name']}*").sort_by { |h| h[:hostname] }

# Collect nodes' public keys
nodes.each do |node|
	authorized_keys << node['public_key']	
end

# Create 'authorized_keys' file withh authorized_keys variable
e = file "/home/#{node['system_user']}/.ssh/authorized_keys" do
  content authorized_keys
  action :create
end

log "Public keys were successfully added"
