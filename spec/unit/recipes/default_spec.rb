#
# Cookbook Name:: sshd
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'sshd::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04')
                        .converge(described_recipe)
  end

  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end

  it 'installs the ssh server package' do
    expect(chef_run).to install_package('openssh-server')
  end

  it 'creates conf file from template' do
    expect(chef_run).to create_template('/etc/ssh/sshd_config')
      .with(source: 'sshd_config.erb')
    expect(chef_run).to render_file('/etc/ssh/sshd_config')
      .with_content('Port 22')
  end
end
