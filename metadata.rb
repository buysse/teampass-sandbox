name             'teampass'
maintainer       'Joshua Buysse'
maintainer_email 'buysse@umn.edu'
license          'Copyright Regents of the University of Minnesota, Apache 2.0 license'
description      'Installs/Configures teampass'
long_description 'Installs/Configures teampass'
version          '0.1.2'

supports "centos", "> 7.0"
supports "redhat", "> 7.0"

depends "httpd", "~> 0.2.17"
depends "php", "~> 1.5.0"
depends "mysql", "~> 6.0.24"
depends "selinux", "~> 0.5.0"
depends "database", "~> 4.0.5"
depends "mysql2_chef_gem", "~> 1.0.0"
depends "ark", "~> 0.9.0"
depends "yum-epel"
depends "apache2", "~> 3.1.0"
