#
# Cookbook Name:: bowtie
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

require 'chef/shell_out'

# Print attributes
log "System user: #{node['system_user']}"
log "Bio soft home: #{node['bio_soft_home']}"
log "Bowtie package uri: #{node['bowtie_package_uri']}"
log "Bowtie package: #{node['bowtie_package']}"
log "Bowtie dir: #{node['bowtie_dir']}"

# Need 'zip'  and 'unzip' installed
log "Installing zip and unzip"
package "zip"
if platform_family?("rhel", "centos")
	package "unzip"
end

# Need 'Bio-soft home' created
log "Creating Bio-soft home"
directory node['bio_soft_home'] do
    owner node['system_user']
    group node['system_user']
    mode 00755
    action :create
end

# Download and Extract Bowtie package
log "Downloading and Extracting Bowtie package"
bash "install bowtie" do
	user node['system_user']
	group node['system_user']
	cwd "/tmp"
	code <<-EOF
		wget #{node['bowtie_package_uri']}
		unzip #{node['bowtie_package']} -d #{node['bio_soft_home']}
	EOF
end

# Set Bowtie home
log "Settting Bowtie home"
bash "set bowtie home" do
	user "root"
	group "root"
	cwd "/root"
	code <<-EOF
		echo 'export PATH=#{node['bio_soft_home']}/#{node['bowtie_dir']}:$PATH' >> /etc/profile && source /etc/profile
	EOF
end
