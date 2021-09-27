sshd CHANGELOG
==============

This file is used to list changes made in each version of the sshd cookbook.

3.1.0
-----

- Add Arch and Amazon linux platforms. Replace foodcritic in Gemfile in favor of cookstyle - [@jhboricua](https://github.com/jhboricua)


3.0.0
-----

- Rename resource from `openssh_server` to `sshd_server`
- Add platforms: centos-8 debian-10 and ubuntu-20
- Apply cookstyle linting

```ruby
# Old notation
sshd_server '/etc/sshd_config' do
  Port 1234
  X11Forward 'no'
end

# New notation
sshd_server '/etc/sshd_config' do
  sshd_config(
    Port: 1234,
    X11Forward: 'no'
  )
end
```


2.0.0
-----

- Migrate definition to resource (finally!)
- Migrate test suite to `inspec`
- Make everything ready for Chef-13

*NOTE: If you upgrade from version 1.x.x and you were using a wrapper cookbook, make sure you update your configuration accordingly. For more details, have a look at the examples in README.md*:

```ruby
# Old notation
open_server '/etc/sshd_config' do
  Port 1234
  X11Forward 'no'
end

# New notation
openssh_server '/etc/sshd_config' do
  sshd_config(
    Port: 1234,
    X11Forward: 'no'
  )
end
```

Detailed CHANGELOG:

- Fixed `rubocop` linting issues
- Fixed travis file
- Removed `minitest` and associated files
- Removed `test-kitchen` gem
- Added `kitchen-inspec` gem
- Updated `kitchen-vagrant` gem
- Created tests using `kitchen-inspec` gem
    - Tests default attributes and `new_resource` attrs.
- Created Matcher for custom resource `openssh_server`
- Added TESTING.md file for supermarket compliance
- Configured tests to work for `delivery`
- Added Ubuntu {16,18}.04
- Added Debian 8 and 9
- Removed Ubuntu {12.x, 13.x}
- Removed CentOS 5
- Removed Debian 5 and 6


1.3.1
-----

- Add support to set `sshd_config` file mode, default to `600` on RHEL

1.3.0
-----

- The install recipe was removed, package installation migrated to the default recipe.
- Duplicate service resource warning was mitingated by removing the (probably useless) service definition in the install recipe.
- Fix issue with `sshd` binary path on rhel. (Thanks Peter Walz)
- Add support for multiple `Port` options (Thanks Kevin Olbrich)
- Fix an issue when both `Port` and `ListenAddress` is specified (Thanks Kevin Olbrich)
- Remove a workaround for chef-client < 11.14 that was overseen in the 1.2.0 release.

1.2.1
-----

- Use attribute bracket syntax (required for Chef 13)

1.2.0
-----

- Remove workaround for chef-client < 11.14, as it breaks Ubuntu Xenial 16.04 LTS

1.1.3
-----

- Fixes a bug in configuration test

1.1.2
-----

- Check `sshd_config` before restarting sshd service

1.1.1
-----

- Fix default XMODIFIERS for RHEL
- Add default attributes for OS X

1.1.0
-----

- Add workaround to set service provider to Upstart on recent Ubuntus (until chef-client is fixed)

1.0.1
-----

- Add support for Ed25519 HostKeys

1.0.0
-----

- Initial release of sshd
