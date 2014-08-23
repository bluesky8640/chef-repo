name             'init_hosts'
maintainer       'BUAA, Org.'
maintainer_email 'bluesky8640@126.com'
license          'All rights reserved'
description      'Installs/Configures init_hosts'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

recipe "init_hosts::default", "Init /etc/hosts and ssh public keys among VMs"
