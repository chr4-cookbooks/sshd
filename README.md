# Description

This cookbook maintains the openssh server.


# Attributes

You can specify the package that installs sshd, using the following attribute.
There's useful defaults for most linux distributions.

    node['sshd']['package'] = 'openssh-server'

The following settings will be filled in using the defaults of the distribution you're using, unless you overwrite it in your node configuration / definition

    default['sshd']['config_file'] = '/etc/sshd/sshd_config'
    default['sshd']['service_name'] = 'sshd'


This recipe takes (or tries to) the default sshd_configuration of your distribution as a base, you can then overwrite specific settings. These are the default settings used

    Port 22
    Protocol 2
    AcceptEnv LANG LC_*
    HostKey /etc/ssh/ssh_host_dsa_key
    HostKey /etc/ssh/ssh_host_ecdsa_key
    HostKey /etc/ssh/ssh_host_rsa_key
    PasswordAuthentication yes
    ChallengeResponseAuthentication no
    X11Forwarding yes
    UsePAM yes

plus, on debian/ubuntu machines

    SyslogFacility AUTH
    GSSAPIAuthentication no
    Subsystem sftp /usr/lib/openssh/sftp-server

and on centos/compatible machines

    SyslogFacility AUTHPRIV
    GSSAPIAuthentication yes
    Subsystem sftp /usr/libexec/openssh/sftp-server


# Recipes

## default

Runs the install recipe, then configures openssh-server according to the attributes given in the node/role.
You can configure openssh-server in your the attributes like this:

    "default_attributes": {
      "sshd": {
        "sshd_config": {
          "Port": 1234,
          "X11Forward": yes,
          "HostKey": [
            "/etc/ssh/ssh_host_dsa_key",
            "/etc/ssh/ssh_host_ecdsa_key",
            "/etc/ssh/ssh_host_rsa_key"
          ],
          "Match": {
            "User fred": { "X11Forwarding": "no" },
            "User john": {
              "ChrootDirectory": "/srv",
              "ForceCommand": "internal-sftp",
              "AllowTcpForwarding": "no",
              "X11Forwarding": "no"
          }
        }
      }
    }

Some entries can be specified multiple times, if you need this, specify them as arrays (as seen in the example above, e.g. "HostKey": [ "key1", "key2"] ).

Conditional blocks are defined using hashes, see the "Match" examples above.


## install

Just installs openssh-server without configuring it, as well as enabling and starting the daemon.

# Definitions

You can maintain openssh-server using definitions from your other cookbooks.
To use them, make sure your metadata.rb includes

    depends 'sshd'


## openssh_server

To install and configure openssh-server from other recipes, use the following definition:

    openssh_server node['sshd']['config_file']

or, if you need a configuration which differs from the default

    openssh_server '/etc/sshd_config' do
      Port 1234
      X11Forward 'no'
    end

The definition accepts all parameters possible according to the sshd_config manpage.
If you want to specify an item multiple times, use an array.
For using conditional blocks, you have to specify them in an additional hash.

    openssh_server node['sshd']['config_file'] do
      Port        1234
      X11Forward  'yes'
      HostKey     [ '/etc/ssh/ssh_host_dsa_key', '/etc/ssh/ssh_host_rsa_key' ]
      Match       'User fred' => { 'X11Forwarding' => 'no' },
                  'User john' => {
                    'ChrootDirectory' => '/srv',
                    'ForceCommand' => 'internal-sftp',
                    'AllowTcpForwarding' => 'no',
                    'X11Forwarding' => 'no'
                  }
    end

It's also possible to specify a cookbook and a source to use instead of the default ones, too:

    openssh_server node['sshd']['config_file'] do
      cookbook 'mycookbook'
      source   'mytemplate.erb'
    end
