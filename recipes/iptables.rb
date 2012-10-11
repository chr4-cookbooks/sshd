#
# Cookbook Name:: sshd
# Recipe:: iptables
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

# iptables firewall rules
allow_ssh = []
Array(node['sshd']['sshd_config']['Port']).each do |port|
  allow_ssh << "--protocol tcp --dport #{port} --match state --state NEW --jump ACCEPT"
end

iptables_rule 'ssh' do
  rule allow_ssh
end
