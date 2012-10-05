Description
===========

This recipe takes the operating systems defaults (or tries to), then overwrites those defaults with any given attributes.


Requirements
============

Attributes
==========

this recipe accepts *all* sshd_options.
Specify them in as key: values in your attributes hash (see usage).
Use arrays if you want to specify an item multiple times.
Use hashes if you need conditional blocks.

    sshd_config: {}


Usage
=====

Just add it to your run-list:

    run_list: [ sshd ]

if you need additional settings in your sshd_config, place them in the default_attributes section of your node or role. You can also set the package to be installed and the sshd_config file manually if you like.


    default_attributes {
      sshd: {
        sshd_config:
          Port: [ 22, 1234 ],
          AllowRootLogin: no
       },

       config_file: "/etc/ssh/sshd_config",
       package: "openssh-server"
       configure_iptables: true
    }
