#
# Cookbook Name:: tophat
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "bowtie::default"
include_recipe "samtools::default"

require 'chef/shell_out'

# Print attributes
log "System user: #{node['system_user']}"
log "Bio soft home: #{node['bio_soft_home']}"
log "Tophat package uri: #{node['tophat_package_uri']}"
log "Tophat package: #{node['tophat_package']}"
log "Tophat dir: #{node['tophat_dir']}"

# Need 'Bio-soft home' created
log "Creating Bio-soft home"
directory node['bio_soft_home'] do
    owner node['system_user']
    group node['system_user']
    mode 00755
    action :create
end

# Download and Extract Tophat package
log "Downloading and Extracting Tophat package"
bash "install tophat" do
	user node['system_user']
	group node['system_user']
	cwd "/tmp"
	code <<-EOF
		wget #{node['tophat_package_uri']}
		tar zxvf #{node['tophat_package']} -C #{node['bio_soft_home']}
	EOF
end

# Set Tophat home
log "Settting Tophat home"
bash "set tophat home" do
	user "root"
	group "root"
	cwd "/root"
	code <<-EOF
		echo 'export PATH=#{node['bio_soft_home']}/#{node['tophat_dir']}:$PATH' >> /etc/profile
		source /etc/profile
	EOF
end
