
# should be attribute driven for locations

directory node['teampass']['download_dir'] do
  action :create
end

# both quietly needed by ark, but not installed by it.
package "unzip"
package "rsync"

package "php-mcrypt" do
  notifies :restart, "service[apache2]"
end
package "php-mbstring" do
  notifies :restart, "service[apache2]"
end
package "php-iconv" do
  notifies :restart, "service[apache2]"
end
package "php-bcmath" do
  notifies :restart, "service[apache2]"
end

ark 'teampass' do
  url node['teampass']['download_url']
  version node['teampass']['version']
  path node['teampass']['download_dir']
  home_dir node['teampass']['docroot']
  owner "apache"
  creates "kb.php"
  action :install
end
