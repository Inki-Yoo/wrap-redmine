chef_gem 'chef-vault'

require 'chef-vault'

redmine_secrets = ChefVault::Item.load('secrets', 'redmine')
node.override['gitlab']['database']['password'] = redmine_secrets['password']
node.override['redmine']['dbpass'] = redmine_secrets['password']

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
