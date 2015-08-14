sshd CHANGELOG
=====================

This file is used to list changes made in each version of the sshd cookbook.

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
