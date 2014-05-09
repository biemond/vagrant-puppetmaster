# == Class: nfs::client
#
# Installs the NFS client software, allowing the mount resource type to mount
# NFS exports.
#
# === Parameters
#
# [*ensure*]
#   Corresponds to the ensure parameter of the Package resource type.
#
# === Variables
#
# This module requires no variables.
#
# === Examples
#
#  class { 'nfs::client':
#    ensure => installed,
#  }
#
# === Authors
#
# Joseph Beard <joseph@josephbeard.net>
#
# === Copyright
#
# Copyright 2014 Joseph Beard
#
class nfs::client (
    $ensure = installed,
) {

    require stdlib

    anchor { 'nfs::client::begin': }

    case $::operatingsystem {
        centos, redhat : {
            class { 'nfs::client::rhel':
                ensure => $ensure,
            }
        }

        debian, ubuntu : {
            class { 'nfs::client::debian':
                ensure => $ensure,
            }
        }

        default : {
            fail("nfs::client is not currently supported on ${::operatingsystem}")
        }
    }

    anchor { 'nfs::client::end': }

}
