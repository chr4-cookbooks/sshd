#
# Cookbook Name:: sshd
# Recipe:: install
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

package node['sshd']['package']

directory File.dirname(node['sshd']['config_file']) do
  owner  'root'
  group  'root'
  mode   '0755'
end

service node['sshd']['service_name'] do
  # Ubuntu-14.04 cannot restart ssh using the default command
  start_command "service #{node['sshd']['service_name']} start" if node['platform'] == 'ubuntu'
  restart_command "service #{node['sshd']['service_name']} restart" if node['platform'] == 'ubuntu'
  stop_command "service #{node['sshd']['service_name']} stop" if node['platform'] == 'ubuntu'
  supports status: true, restart: true, reload: true
  action [ :enable, :restart ]
end
