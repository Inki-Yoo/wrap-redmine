redmine_secrets = Chef::EncryptedDataBagItem.load('secrets', 'redmine')
node.override['gitlab']['database']['password'] = redmine_secrets['password']

include_recipe 'redmine'

include_recipe 'wrapper-redmine::redmine_plugins'

include_recipe 'wrapper-redmine::sync_repos'

ruby_block 'wipe gitlab password' do
  block do
    node.force_override['gitlab']['database']['password'] = ''
  end
  action :create
end
