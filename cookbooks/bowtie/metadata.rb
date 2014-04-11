name             'bowtie'
maintainer       'BUAA, Org'
maintainer_email 'bluesky8640@126.com'
license          'All rights reserved'
description      'Installs/Configures bowtie'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'
depends			 'zip'

recipe "bowtie::default", "install bowtie"
