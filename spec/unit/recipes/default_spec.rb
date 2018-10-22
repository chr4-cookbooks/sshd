#
# Cookbook Name:: sshd
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'sshd::default' do
  context 'when run on Ubuntu 18.04' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '18.04')
                          .converge(described_recipe)
    end

    it 'converges successfully' do
      expect { :chef_run }.to_not raise_error
    end

    it 'installs the ssh server package' do
      expect(chef_run).to install_package('openssh-server')
    end

    it 'creates ssh directory' do
      expect(chef_run).to create_directory('/etc/ssh')
    end

    it 'executes custom resource' do
      expect(chef_run).to create_openssh_server('/etc/ssh/sshd_config')
    end
  end
end
