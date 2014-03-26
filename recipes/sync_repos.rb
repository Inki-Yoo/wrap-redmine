chef_gem 'chef-vault'

require 'chef-vault'
redmine_secrets = ChefVault::Item.load('secrets', 'redmine')

directory node['redmine']['script_dir'] do
  user   node['redmine']['user']
  group  node['redmine']['group']
  mode   '750'
  action :create
end

cookbook_file node['redmine']['script_dir'] + '/Gemfile' do
  user   node['redmine']['user']
  group  node['redmine']['group']
  mode   '640'
  action :create_if_missing
end

execute 'bundle install' do
  cwd    node['redmine']['script_dir']
  command 'bundle install'
end

template node['redmine']['script_dir'] + '/redmine_reposync.rb' do
  user   node['redmine']['user']
  group  node['redmine']['group']
  mode   '750'
  action :create
  variables(
           protocol: 'http',
           gitlaburl: 'gitlab.local',
           redminetoken: redmine_secrets['token'],
           )
end
