#
# Cookbook:: sshd
# Definition:: sshd_server
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

property :sshd_config, Hash, default: {}
property :template_action, default: :create
property :cookbook, String, default: 'sshd'
property :source, String, default: 'sshd_config.erb'

action_class do
  include Sshd::Helpers
end

action :create do
  filename        = new_resource.name
  sshd_config     = new_resource.sshd_config
  template_action = new_resource.template_action
  cookbook        = new_resource.cookbook
  source          = new_resource.source

  # generate sshd_config according to attributes
  # use default values, overwrite them with the ones in the resource
  sshd_config = generate_sshd_config(new_resource.params.merge(node['sshd']['sshd_config'].merge(sshd_config)))

  # Check sshd_config
  execute 'check_sshd_config' do
    command "#{node['sshd']['sshd_path']} -t -f #{filename}"
    only_if { node['sshd']['sshd_config']['HostKey'].map { |f| ::File.exist?(f) }.include?(true) }
    action :nothing
  end

  service node['sshd']['service_name'] do
    supports status: true, restart: true, reload: true
    action :nothing
  end

  directory '/run/sshd' do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
    only_if { platform?('debian', 'ubuntu') }
  end

  template filename do
    owner     'root'
    group     node['root_group']
    mode      node['sshd']['sshd_config_mode']
    cookbook  cookbook
    source    source
    variables config: sshd_config
    action    template_action

    # Test sshd_config before actually restarting
    notifies :run, 'execute[check_sshd_config]', :immediately
    notifies :restart, "service[#{node['sshd']['service_name']}]", :delayed
  end
end
