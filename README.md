# Description

This cookbook maintains the openssh server.

Unlike other sshd cookbooks, this cookbook respects the default settings of the
current operating systems, unless these settings are explicitly overwritten.

This cookbook takes (or at least tries to) the default sshd configruation of the
distribution you are using as a default. Then you can overwrite specific
settings.

See below for the default settings.


## Attributes

You can specify the package that installs sshd, using the following attribute.
There's  defaults for most linux distributions.

```ruby
node['sshd']['package']      # Package to install openssh-server
```

The following settings will be filled in using the defaults of the distribution you're using, unless you overwrite it in your node configuration / definition

```ruby
node['sshd']['sshd_path']    # Path to sshd executable
node['sshd']['config_file']  # Path to sshd_config
node['sshd']['service_name'] # OpenSSH service name
```

You can specify every configuration option that openssh-server supports in the
`sshd_config` attribute. The settings you specify will be merged with the
distributions default settings.

```ruby
node['sshd']['sshd_config']['Port'] = 22
```

Conditional blocks are defined using hashes

```ruby
node['sshd']['sshd_config']['Match']['User fred']['X11Forwarding'] = 'no'
node['sshd']['sshd_config']['Match'] = {
  'User john' => {
    'ChrootDirectory' => '/srv',
    'ForceCommand' => 'internal-sftp',
    'AllowTcpForwarding' => 'no',
    'X11Forwarding' => 'no'
  }
}
```

Some configuration options can be specified multiple times. You can reflect this
using an array

```ruby
node['sshd']['sshd_config']['HostKey'] = %w(key1 key2)
```


## Recipes

### default

Runs the install recipe, then configures openssh-server according to the node attributes.

### install

Just installs openssh-server without configuring it, as well as enabling and starting the daemon.


## Definitions

You can also maintain openssh-server using the definition. This is the
recommended way.

To use the definition, make sure your metadata.rb includes

```ruby
depends 'sshd'
```

### openssh\_server

To install and configure openssh-server from other recipes, use the following definition:

```ruby
openssh_server node['sshd']['config_file']
```

or, if you need a configuration which differs from the default

```ruby
openssh_server '/etc/sshd_config' do
  Port 1234
  X11Forward 'no'
end
```

The definition accepts all configuration options `sshd_config` supports.

```ruby
openssh_server node['sshd']['config_file'] do
  Port        1234
  X11Forward  'yes'

  # To specify an option multiple times, use an array
  HostKey     %w(/etc/ssh/ssh_host_dsa_key /etc/ssh/ssh_host_rsa_key)

  # For conditional blocks, use a hash
  Match       'User fred' => { 'X11Forwarding' => 'no' },
              'User john' => {
                'ChrootDirectory' => '/srv',
                'ForceCommand' => 'internal-sftp',
                'AllowTcpForwarding' => 'no',
                'X11Forwarding' => 'no'
              }
end
```

In case you need it, you can also use a custom template to use for `sshd_config`

```ruby
openssh_server node['sshd']['config_file'] do
  cookbook 'mycookbook'
  source   'mytemplate.erb'
end
```


## Default sshd\_config settings

The following options are set by default

```
Port 22
Protocol 2
AcceptEnv LANG LC_*
HostKey /etc/ssh/ssh_host_ed25519_key
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_dsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
PasswordAuthentication yes
ChallengeResponseAuthentication no
X11Forwarding yes
UsePAM yes
```

Plus, on debian/ubuntu machines

```
SyslogFacility AUTH
GSSAPIAuthentication no
Subsystem sftp /usr/lib/openssh/sftp-server
```

And on centos/compatible machines

```
SyslogFacility AUTHPRIV
GSSAPIAuthentication yes
Subsystem sftp /usr/libexec/openssh/sftp-server
```

# Contributing

You fixed a bug, or added a new feature? Yippie!

1. Fork the repository on Github
2. Create a named feature branch (like `add\_component\_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

Contributions of any sort are very welcome!

# License and Authors

Authors: Chris Aumann <me@chr4.org>
Contributors: Jeremy Olliver, Andy Thompson, Peter Walz, Kevin Olbrich
