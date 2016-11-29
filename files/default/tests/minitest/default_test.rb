#
# Cookbook Name:: sshd
# Test:: default
#
# Copyright 2013, Chris Aumann
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

require File.expand_path('../support/helpers', __FILE__)

describe 'sshd::default' do
  include Helpers::TestHelper

  it 'should install openssh-server' do
    package(node['sshd']['package']).must_be_installed
  end

  it 'should create sshd_config according to specifications' do
    file(node['sshd']['config_file']).must_include('Port 1234')
    if node['sshd']['sshd_config']['ListenAddress']
      file(node['sshd']['config_file']).must_match(/Port.+ListenAddress/m)
    end
  end

  it 'should start openssh-server service' do
    service(node['sshd']['service_name']).must_be_running
  end

  # This fails on recent Ubuntu machines with Upstart
  # it 'should enable openssh-server service' do
  #   service(node['sshd']['service_name']).must_be_enabled
  # end
end
