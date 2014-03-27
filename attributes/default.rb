default['redmine']['script_dir'] = node['redmine']['home'] + '/scripts'

override['gitlab']['nginx_server_names'] = ['gitlab.*', 'trigitlab.*']
override['gitlab']['install_ruby'] = 'package'
override['gitlab']['install_ruby_path'] = '/usr/local'
override['gitlab']['cookbook_dependencies'] = %w[
  build-essential git openssh readline xml zlib sudo ruby_build
  redisio::install redisio::enable
]
