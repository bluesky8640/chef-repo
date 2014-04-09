#
# Cookbook Name:: bowtie
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

require 'chef/shell_out'

# Install zip
log "Installing zip"
package "zip" do
	action :install
end

# Download Bowtie package
log "Downloading Bowtie package"
download_bowtie = Mixlib:Sh
