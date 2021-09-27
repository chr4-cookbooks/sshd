name             'sshd'
maintainer       'Chris Aumann'
maintainer_email 'me@chr4.org'
license          'GPL-3.0-or-later'
description      'Installs/Configures sshd'
version          '3.1.0'
source_url       'https://github.com/chr4-cookbooks/sshd'
issues_url       'https://github.com/chr4-cookbooks/sshd/issues'

%w(amazon centos debian fedora redhat ubuntu).each do |os|
  supports os
end

chef_version '>= 15.0'
