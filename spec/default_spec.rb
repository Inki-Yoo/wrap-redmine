require 'spec_helper'

describe 'redmine::default' do
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

  %w{redmine::default
    }.each do |rec|
    it "should include the #{rec} recipe" do
      expect(chef_run).to include_recipe(rec)
    end
  end

end
