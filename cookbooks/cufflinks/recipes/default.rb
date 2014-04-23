#
# Cookbook Name:: cufflinks
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
log "Cufflinks package uri: #{node['cufflinks_package_uri']}"
log "Cufflinks package: #{node['cufflinks_package']}"
log "Cufflinks dir: #{node['cufflinks_dir']}"

# Need 'Bio-soft home' created
log "Creating Bio-soft home"
directory node['bio_soft_home'] do
    owner node['system_user']
    group node['system_user']
    mode 00755
    action :create
end

# Download and Extract Cufflinks package
log "Downloading and Extracting Cufflinks package"
bash "install cufflinks" do
	user node['system_user']
	group node['system_user']
	cwd "/tmp"
	code <<-EOF
		wget #{node['cufflinks_package_uri']}
		tar zxvf #{node['cufflinks_package']} -C #{node['bio_soft_home']}
	EOF
end

# Set Cufflinks path
log "Setting Cufflinks path"
bash "set cufflinks path" do
	user "root"
	group "root"
	cwd "/usr/bin"
	code <<-EOF
		ln -s #{node['bio_soft_home']}/#{node['cufflinks_dir']}/cufflinks
		ln -s #{node['bio_soft_home']}/#{node['cufflinks_dir']}/cuffcompare
		ln -s #{node['bio_soft_home']}/#{node['cufflinks_dir']}/cuffmerge
		ln -s #{node['bio_soft_home']}/#{node['cufflinks_dir']}/cuffdiff
		ln -s #{node['bio_soft_home']}/#{node['cufflinks_dir']}/cuffnorm
		ln -s #{node['bio_soft_home']}/#{node['cufflinks_dir']}/cuffquant
		ln -s #{node['bio_soft_home']}/#{node['cufflinks_dir']}/gffread
		ln -s #{node['bio_soft_home']}/#{node['cufflinks_dir']}/gtf_to_sam
	EOF
end
