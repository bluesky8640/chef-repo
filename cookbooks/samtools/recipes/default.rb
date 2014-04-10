#
# Cookbook Name:: samtools
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

require 'chef/shell_out'

# Need 'make' installed
log "Installing make"
package "make" do
	action :install
end

# Need 'zlib1g-dev' installed
log "Installing zlib1g-dev"
package "zlib1g-dev" do
	action :install
end

# Need 'libncurses5-dev' installed
log "Installing libncurses5-dev"
package "libncurses5-dev" do
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

# Download Samtools package
log "Downloading Samtools package"
download_samtools = Mixlib::ShellOut.new("wget #{node['samtools_package_uri']}", :user => node['current_user'], :cwd => '/tmp')
download_samtools.run_command

# Extract Samtools package
log "Extracting samtools package"
extract_samtools = Mixlib::ShellOut.new("tar jxvf #{node['samtools_package']} -C #{node['bio_soft_home']}", :user => node['current_user'], :cwd => '/tmp')
extract_samtools.run_command

# Make samtools
log "Making samtools"
make_samtools = Mixlib::ShellOut.new("make", :user => node['current_user'], :cwd => "#{node['bio_soft_home']}/#{node['samtools_dir']}")
make_samtools.run_command

if !(make_samtools.error!)
	log "Make samtools ok"
else
	log "Make samtools failed"
end

# Set Samtools home
log "Setting Samtools home"
set_samtools_home = Mixlib::ShellOut.new("echo 'export PATH=#{node['bio_soft_home']}/#{node['samtools_dir']}:$PATH' >> /etc/profile && source /etc/profile", :user => "root", :cwd => "/root")
set_samtools_home.run_command

if !(set_samtools_home!)
	log "Samtools home was successfully set"
else
	log "samtools home was not set"
end