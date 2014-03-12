redmine_plugin 'redmine_spent_time' do
  source 'https://github.com/eyp/redmine_spent_time.git'
  source_type 'git'
  run_bundler true
  restart_redmine true
end
