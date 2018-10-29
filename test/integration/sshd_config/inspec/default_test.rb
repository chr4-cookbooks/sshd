pkg = case os.family
      when 'linux'
        'openssh'
      else
        'openssh-server'
      end

svc = case os.family
      when 'debian'
        'ssh'
      else
        'sshd'
      end

config_filepath = case os.family
                  when 'bsd'
                    '/etc/sshd_config'
                  else
                    '/etc/ssh/sshd_config'
                  end

describe package(pkg) do
  it { should be_installed }
end

describe service(svc) do
  it { should be_installed }
  it { should be_running }
end

describe file(config_filepath) do
  it { should exist }
  its('content') { should match('ListenAddress 0.0.0.0') }
  its('content') { should match('ServerKeyBits 2048') }
  its('content') { should match('PasswordAuthentication no') }
end
