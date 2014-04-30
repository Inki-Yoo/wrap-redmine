chef_gem 'chef-vault'

require 'chef-vault'

redmine_secrets = ChefVault::Item.load('secrets', 'redmine')
node.override['gitlab']['database']['password'] = redmine_secrets['password']
node.override['redmine']['dbpass'] = redmine_secrets['password']

# Need to install subversion first and set the proxy config
package 'subversion'

unless Chef::Config[:http_proxy].nil?
  ENV['http_proxy'] = URI.parse(Chef::Config[:http_proxy]).to_s
  svn_prx_host = URI.parse(Chef::Config[:http_proxy]).host
  svn_prx_port = URI.parse(Chef::Config[:http_proxy]).port
end

unless Chef::Config[:http_proxy].nil?
  ENV['https_proxy'] = URI.parse(Chef::Config[:https_proxy]).to_s
  svn_ssl_prx_host = URI.parse(Chef::Config[:https_proxy]).host
  svn_ssl_prx_port = URI.parse(Chef::Config[:https_proxy]).port
end

unless Chef::Config[:http_proxy].nil?
  template '/etc/subversion/servers' do
    owner 'root'
    group 'root'
    variables(
      svn_prx_host: svn_prx_host,
      svn_prx_port: svn_prx_port,
      svn_ssl_prx_host: svn_ssl_prx_host,
      svn_ssl_prx_port: svn_ssl_prx_port
    )
  end
end

include_recipe 'redmine'

include_recipe 'wrapper-redmine::redmine_plugins'

include_recipe 'wrapper-redmine::sync_repos'

include_recipe 'gitlab'

ruby_block 'wipe gitlab and redmine passwords' do
  block do
    node.force_override['gitlab']['database']['password'] = '<redacted>'
    node.force_override['redmine']['dbpass'] = '<redacted>'
  end
  action :create
end
