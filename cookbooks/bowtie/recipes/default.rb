#
# Cookbook Name:: bowtie
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

require 'chef/shell_out'

# Need 'zip' installed
log "Installing zip"
package "zip" do
    action :install
end

# Need 'Bio-soft home' created
log "Creating Bio-soft home"
directory node['bio_soft_home'] do
    owner node['current_user']
    group node['current_user']
    mode 00755
    action :create
end

# Download Bowtie package
log "Downloading Bowtie package"
download_bowtie = Mixlib::ShellOut.new("wget #{node['bowtie_package_uri']}", :user => node['current_user'], :cwd => '/tmp')
download_bowtie.run_command

# Extract Bowtie package
log "Extracting Bowtie package"
extract_bowtie = Mixlib::ShellOut.new("unzip #{node['bowtie_package']} -d #{node['bio_soft_home']}", :user => node['current_user'], :cwd => '/tmp')
extract_bowtie.run_command

# Set Bowtie home
log "Setting Bowtie home"
set_bowtie_home = Mixlib::ShellOut.new("echo 'export PATH=#{node['bio_soft_home']}/#{node['bowtie_dir']}:$PATH' >> /etc/profile", :user => "root", :cwd => "/root")
set_bowtie_home.run_command

if !(set_bowtie_home.error!)
    log "Set bowtie home ok"
else 
    log "Set bowtie home failed"
end
