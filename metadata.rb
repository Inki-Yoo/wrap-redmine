name             'wrapper-redmine'
maintainer       'trilitheus'
maintainer_email 'trilitheus@gmail.com'
license          'All rights reserved'
description      'Installs/Configures redmine'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

%w{
  apt
  mysql
  database
  subversion
  ruby_build
  git
  nginx
  build-essential
  redmine
  }.each do |cb|
  depends cb
end

depends 'ohai', '~> 1.1.10'