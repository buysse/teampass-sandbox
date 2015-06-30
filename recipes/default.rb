#
# Cookbook Name:: teampass
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "yum-epel::default"

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

node.set['apache']['mpm'] = 'prefork'
include_recipe 'apache2::default'

include_recipe 'php::default'

include_recipe 'apache2::mod_php5'

package "php-mysql" do
  action :remove
  notifies :restart, "service[apache2]"
end
package "php-mysqlnd" do
  notifies :restart, "service[apache2]"
end

web_app 'default' do
  server_name node['fqdn']
  server_aliases = ['localhost']
  template 'teampass_site.conf.erb'
  docroot node['teampass']['docroot']
  extra_lines([
    'php_value max_execution_time 60'
  ])
  notifies :restart, "service[apache2]"
end

# set up the database

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
