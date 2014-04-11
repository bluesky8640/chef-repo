#
# Cookbook Name:: samtools
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
log "Samtools package uri: #{node['samtools_package_uri']}"
log "Samtools package: #{node['samtools_package']}"
log "Samtools dir: #{node['samtools_dir']}"

# Need 'make' installed
log "Installing make"
package "make"

# Need 'zlib1g-dev' installed
log "Installing zlib1g-dev"
package "zlib1g-dev"

# Need 'libncurses5-dev' installed
log "Installing libncurses5-dev"
package "libncurses5-dev"

# Need 'Bio-soft home' created
log "Creating Bio-soft home"
directory node['bio_soft_home'] do
    owner node['system_user']
    group node['system_user']
    mode 00755
    action :create
end

# Download and Extract Samtools package
log "Downloading and Extracting Samtools package"
bash "install samtools" do
	user node['system_user']
	group node['system_user']
	cwd "/tmp"
	code <<-EOF
		wget #{node['samtools_package_uri']}
		tar jxvf #{node['samtools_package']} -C #{node['bio_soft_home']}
	EOF
end

# Make Samtools
log "Making Samtools"
bash "make samtools" do
	user node['system_user']
	group node['system_user']
	cwd "#{node['bio_soft_home']}/#{node['samtools_dir']}"
	code <<-EOF
		make
	EOF
end

# Set Samtools path
log "Settting Samtools path"
bash "set samtools path" do
	user "root"
	group "root"
	cwd "/usr/bin"
	code <<-EOF
		ln -s #{node['bio_soft_home']}/#{node['samtools_dir']}/samtools
	EOF
end
