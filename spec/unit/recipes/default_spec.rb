#
# Cookbook Name:: sshd
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'sshd::default' do
  context 'When all attributes are default, on Ubuntu 14.04' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    describe 'configuration file' do
      it { expect(chef_run).to render_file('/etc/ssh/sshd_config') }

      it 'Port is before ListenAddress when both are defined' do
        chef_run.node.normal['sshd']['sshd_config'] = {
          'Port' => 2222,
          'ListenAddress' => '0.0.0.0'
        }
        chef_run.converge(described_recipe)
        expect(chef_run).to render_file('/etc/ssh/sshd_config').with_content(/Port 2222.+ListenAddress 0\.0\.0\.0/m)
      end

      it 'has multiple Port entries when an array is given' do
        chef_run.node.normal['sshd']['sshd_config'] = {
          'Port' => [2222, 22]
        }
        chef_run.converge(described_recipe)
        expect(chef_run).to render_file('/etc/ssh/sshd_config').with_content("Port 2222\nPort 22\n")
      end
    end
  end
end
