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

gss_api_value = case os.family
                when 'redhat', 'linux'
                  'yes'
                else
                  'no'
                end

syslog_value = case os.family
               when 'redhat', 'linux', 'bsd'
                 'AUTHPRIV'
               else
                 'AUTH'
               end

x11_value = case os.family
            when 'bsd'
              'no'
            else
              'yes'
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
  its('content') { should match('Port 22') }
  its('content') { should match('Protocol 2') }
  its('content') { should match('PasswordAuthentication yes') }
  its('content') { should match('UsePAM yes') }
  its('content') { should match('ChallengeResponseAuthentication no') }

  its('content') { should match("GSSAPIAuthentication #{gss_api_value}") }
  its('content') { should match("SyslogFacility #{syslog_value}") }
  its('content') { should match("X11Forwarding #{x11_value}") }
end
