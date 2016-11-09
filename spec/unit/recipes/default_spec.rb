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

    before do
      #allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_return(true)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates a configuration file' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config')
    end

    context 'when Port and ListenAddress are defined' do
      before do
        chef_run.node.normal['sshd']['sshd_config'] = {
          'Port' => [2222,22],
          'ListenAddress' => '0.0.0.0'
          }
        chef_run.converge(described_recipe)
      end

      it 'creates a configuration file with Port listed before ListenAddress' do
        expect(chef_run).to render_file('/etc/ssh/sshd_config').with_content(/Port.+ListenAddress/m)
      end
    end
  end
end
