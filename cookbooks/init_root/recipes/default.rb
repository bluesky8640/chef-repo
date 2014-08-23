#
# Cookbook Name:: init_root
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

require 'chef/shell_out'


## Update apt-get
log "Update apt-get"
apt_update = Mixlib::ShellOut.new("apt-get update", :user => 'root', :cwd => "/root")
apt_update.run_command

if !(apt_update.error!)
    log "Apt update successfully!"
else
    log "Apt update failed!" do
        level :warn
    end
end


## Modify root user
# password = Mixlib::ShellOut.new("mkpasswd -m sha-512 #{node['hadoop_user_password']}")
password = Mixlib::ShellOut.new("openssl passwd -1 #{node['root_password']}")
password.run_command

log "Modify root user"
user "root" do
    password password.stdout.chomp
	action :modify
end

## Configure NFS
log "Installing nfs-common"
package "nfs-common"

log "Make shared directory"
directory "/home/jinchao/shared_home" do
	owner "jinchao"
	group "jinchao"
	mode 00755
	action :create
end

log "Mount shared directory"
bash "mount shared dir" do
	user "root"
	group "root"
	code <<-EOF
		mount -t nfs saasslave04:/home/jinchao/shared_home /home/jinchao/shared_home
	EOF
end
