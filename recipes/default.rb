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

class Chef::Recipe
  include Sshd::Helpers
end


package node['sshd']['package']

directory File.dirname(node['sshd']['config_file']) do
  owner     'root'
  group     'root'
  mode      '0755'
end


# generate sshd_config file according to attributes
sshd_config = generate_sshd_config

template node['sshd']['config_file'] do
  owner     'root'
  group     'root'
  mode      '0644'
  cookbook  'sshd'
  source    'sshd_config.erb'
  variables :config => sshd_config
end


service node['sshd']['service_name'] do
  subscribes :restart, resources(:template => node['sshd']['config_file'])
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end


# iptables firewall rules
if node['sshd']['configure_iptables']
  Array(node['sshd']['sshd_config']['Port']).each do |port|
    iptables_rule 'ssh' do
      rule "--protocol tcp --dport #{port} --match state --state NEW --jump ACCEPT"
    end
  end
end