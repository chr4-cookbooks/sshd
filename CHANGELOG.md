sshd CHANGELOG
=====================

This file is used to list changes made in each version of the sshd cookbook.

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
