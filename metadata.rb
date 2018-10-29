name             'sshd'
maintainer       'Chris Aumann'
maintainer_email 'me@chr4.org'
license          'GPL-3.0-or-later'
description      'Installs/Configures sshd'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.0.0'
source_url       'https://github.com/chr4-cookbooks/sshd' if respond_to?(:source_url)
issues_url       'https://github.com/chr4-cookbooks/sshd/issues' if respond_to?(:issues_url)

%w(ubuntu debian redhat centos).each do |os|
  supports os
end

chef_version '>= 12.7' if respond_to?(:chef_version)
