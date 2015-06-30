#
# Cookbook Name:: teampass
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

mysql_connection_info = {
  :host => '127.0.0.1',
  :username => 'root',
  :socket => '/var/run/mysql-default/mysqld.sock',
  :password => 'testkitchen@w00t'
}


mysql_client 'default' do
  action :create
end

mysql2_chef_gem 'default' do
  action :install
end

include_recipe 'selinux::disabled'

httpd_service 'default' do
  mpm 'prefork'
  listen_ports ['80', '443']
  action [:create, :start]
end

include_recipe 'php::default'

httpd_module 'php' do
  instance 'default'
  notifies :restart, "httpd_service[default]"
end

package "php-mysql" do
  notifies :restart, "httpd_service[default]"
end

httpd_config 'enable_php_mappings' do
  source 'httpd_config_arbitrary.erb'
  instance 'default'
  notifies :restart, 'httpd_service[default]'
  variables(
    'lines' => [
      '<Directory />',
      '  DirectoryIndex index.php index.html index.htm default.html default.htm',
      '</Directory>',
      '',
      '<FilesMatch \.php$>',
      '  SetHandler application/x-httpd-php',
      '</FilesMatch>',
      'AddType text/html .php',
      'php_value session.save_handler "files"',
      'php_value session.save_path    "/var/lib/php/session"',
      'php_value max_execution_time 60'
    ]
  )
end

httpd_config 'default' do
  source 'teampass_site.conf.erb'
  variables(
    'docroot' => node['teampass']['docroot'],
    'extra_lines' => ['']
  )
  instance 'default'
  notifies :restart, 'httpd_service[default]'
end

mysql_service 'default' do
  port '3306'
  bind_address '127.0.0.1'
  initial_root_password 'testkitchen@w00t'
  action [:create, :start]
end

mysql_database 'teampass' do
  connection mysql_connection_info
  action :create
end

mysql_database_user 'teampass' do
  connection mysql_connection_info
  password 'teampass@w00t'
  database_name 'teampass'
  host '%'
  privileges [:all]
  action [:create, :grant]
end

include_recipe 'teampass::teampass'
