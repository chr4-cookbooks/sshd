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
  if node.platform == 'ubuntu' and node.platform_version.to_f > 12.04
    provider Chef::Provider::Service::Upstart
  end

  supports status: true, restart: true, reload: true
  action [ :enable, :start ]
end
