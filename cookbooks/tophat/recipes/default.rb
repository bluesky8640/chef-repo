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

# Need 'Bio-soft home' created
log "Creating Bio-soft home"
directory node['bio_soft_home'] do
    owner node['current_user']
    group node['current_user']
    mode 00755
    action :create
end

# Download Tophat package
log "Downloading Tophat package"
download_tophat = Mixlib::ShellOut.new("wget #{node['tophat_package_uri']}", :user => node['current_user'], :cwd => '/tmp')
download_tophat.run_command

# Extract Tophat package
log "Extracting Tophat package"
extract_tophat = Mixlib::ShellOut.new("tar zxvf #{node['tophat_package']} -C #{node['bio_soft_home']}", :user => node['current_user'], :cwd => '/tmp')
extract_tophat.run_command

# Set Tophat home
log "Setting Tophat home"
set_tophat_home = Mixlib::ShellOut.new("echo 'export PATH=#{node['bio_soft_home']}/#{node['tophat_dir']}:$PATH' >> /etc/profile && source /etc/profile", :user => "root", :cwd => "/root")
set_tophat_home.run_command

if !(set_tophat_home.error!)
    log "Set tophat home ok"
else 
    log "Set tophat home failed"
end
