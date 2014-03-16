require 'spec_helper'

describe 'wrapper-redmine::sync_repos' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['mysql']['server_debian_password'] = 'password'
      node.set['mysql']['server_root_password'] = 'password'
      node.set['mysql']['server_repl_password'] = 'password'
      node.automatic['platform_family'] = 'debian'
      node.automatic['lsb']['codename'] = 'precise'
    end.converge(described_recipe)
  end

  before do
    stub_command("\"/usr/bin/mysql\" -u root -e 'show databases;'").and_return(true)
  end

  it 'creates directory /srv/redmine/scripts owned by redmine:redmine' do
    expect(chef_run).to create_directory('/srv/redmine/scripts').with(
      user:  'redmine',
      group: 'redmine',
      mode:  '750',
    )
  end

  it 'creates cookbook_file /srv/redmine/scripts/Gemfile if it is missing' do
    expect(chef_run).to create_cookbook_file_if_missing('/srv/redmine/scripts/Gemfile').with(
      user:  'redmine',
      group: 'redmine',
      mode:  '640',
    )
  end

  it 'should execute bundle install in directory /srv/redmine/scripts' do
    expect(chef_run).to run_execute('bundle install').with(cwd: '/srv/redmine/scripts')
  end

  it 'should render template /srv/redmine/scripts/redmine_reposync.rb' do
    expect(chef_run).to create_template('/srv/redmine/scripts/redmine_reposync.rb')
  end

end
