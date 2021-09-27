#
# Cookbook:: sshd
# Attributes:: default
#
# Copyright:: 2012, Chris Aumann
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# The package to install
default['sshd']['package'] =
  if platform?('arch', 'suse')
    'openssh'
  else
    'openssh-server'
  end

# Path to 'sshd' executable
default['sshd']['sshd_path'] =
  if platform?('redhat', 'centos')
    node['platform_version'].to_i >= 7 ? '/sbin/sshd' : '/usr/sbin/sshd'
  else
    '/usr/sbin/sshd'
  end

# Path to 'sshd_config' configuration file
default['sshd']['config_file'] =
  if platform_family?('mac_os_x')
    '/etc/sshd_config'
  else
    '/etc/ssh/sshd_config'
  end

# OpenSSH service name
default['sshd']['service_name'] =
  if platform_family?('debian')
    'ssh'
  else
    'sshd'
  end

# Define sshd_config attributes
default['sshd']['sshd_config'] = {
  'Port' => 22,
  'Protocol' => 2,
  'AcceptEnv' => 'LANG LC_*',
  'HostKey' => %w(/etc/ssh/ssh_host_rsa_key
                  /etc/ssh/ssh_host_ed25519_key
                  /etc/ssh/ssh_host_dsa_key
                  /etc/ssh/ssh_host_ecdsa_key),
  'PasswordAuthentication' => 'yes',
  'ChallengeResponseAuthentication' => 'no',
  'X11Forwarding' => 'yes',
  'UsePAM' => 'yes',
  'SyslogFacility' => 'AUTH',
  'GSSAPIAuthentication' => 'no',
}

# sshd_config permissions
default['sshd']['sshd_config_mode'] =
  case node['platform_family']
  when 'debian', 'mac_os_x'
    '0o644'
  when 'amazon', 'arch', 'fedora', 'rhel'
    '0o600'
  end

# Initialize sftp subsystem
default['sshd']['sshd_config']['Subsystem'] =
  case node['platform_family']
  when 'arch'
    'sftp /usr/lib/ssh/sftp-server'
  when 'debian'
    'sftp /usr/lib/openssh/sftp-server'
  when 'amazon', 'fedora', 'rhel'
    'sftp /usr/libexec/openssh/sftp-server'
  when 'mac_os_x'
    'sftp /usr/libexec/sftp-server'
  end

case node['platform_family']
when 'amazon'
  default['sshd']['sshd_config']['SyslogFacility'] = 'AUTHPRIV'
  default['sshd']['sshd_config']['AcceptEnv'] = 'LANG LANGUAGE LC_* XMODIFIERS'

when 'arch'
  default['sshd']['sshd_config']['SyslogFacility'] = 'AUTH'
  default['sshd']['sshd_config']['X11Forwarding'] = 'no'

when 'debian'
  # On debian-like systems, pam takes care of the motd
  default['sshd']['sshd_config']['PrintMotd'] = 'no'

when 'rhel', 'fedora'
  default['sshd']['sshd_config']['SyslogFacility'] = 'AUTHPRIV'
  default['sshd']['sshd_config']['GSSAPIAuthentication'] = 'yes'
  default['sshd']['sshd_config']['AcceptEnv'] = 'LANG LANGUAGE LC_* XMODIFIERS'

when 'mac_os_x'
  default['sshd']['sshd_config']['SyslogFacility'] = 'AUTHPRIV'
  default['sshd']['sshd_config']['UsePrivilegeSeparation'] = 'sandbox'
  default['sshd']['sshd_config']['X11Forwarding'] = 'no'
end
