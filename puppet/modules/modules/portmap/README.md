#portmap

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with portmap](#setup)
    * [What portmap affects](#what-portmap-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with portmap](#beginning-with-portmap)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)

##Overview
This is a module designed for controlling the [Portmap][wikipedia] daemon.

##Module Description
This module installs and runs the [Portmap][wikipedia] daemon for use by NFS and others.

##Setup

###What portmap affects
The portmap module will install the appropriate packages for RedHat and Debian distributions.
This typically includes either the `rpcbind` or `portmap` packages, depending on OS version.
It also controls execution of the appropriate daemon services.  These are typically either
`rpcbind` or `portmap`, depending on OS version.

###Setup requirements
This module requires the [puppetlabs/stdlib][stdlib] module.

###Beginning with portmap
Simply including this module will install and execute the portmap service on your host.

> include portmap

##Usage
By default, the module will install the appropriate packages and configure the daemon to start on boot.
All user interaction is done at the top-level `portmap` module level.  In other words, options are
provided directly to the `portmap` class.

The `package` option is used to specify which version of the portmap package to install.  This will
typically be either `installed` (or `present`) or `latest`.

The `service` option is used to specify whether the portmap service should execute.  This will typically
be either `running` or `stopped`.

The `enable` option is used to specify whether the service should start at boot.  The value will be
either `true` or `false`.

##Reference
_TODO_ List all the classes and organization

##Limitations
The portmap module is currently only supported on RedHat Enterprise Linux 5/6, CentOS 5/6, Debian and
Ubuntu 12.04 LTS, 13.10, and 14.04.

##Development
_TODO_ Document development practices

[wikipedia]: http://en.wikipedia.org/wiki/Portmap "Portmap - Wikipedia, the free encyclopedia"
[stdlib]: http://forge.puppetlabs.com/puppetlabs/stdlib "puppetlabs/stdlib - Puppet Forge"

