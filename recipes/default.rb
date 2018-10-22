#
# Cookbook Name:: sshd
# Recipe:: default
#
# Copyright 2012, Chris Aumann
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

# Install package

package node['sshd']['package']

# Create configuration directory
directory File.dirname(node['sshd']['config_file']) do
  owner  'root'
  group  node['root_group']
  mode   0o755
end

# Configure service
openssh_server node['sshd']['config_file'] do
  name            node['sshd']['config_file']
  cookbook        'sshd'
  source          'sshd_config.erb'
  action          :create
end
