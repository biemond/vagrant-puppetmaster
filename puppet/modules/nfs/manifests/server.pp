# == Class: nfs::server
#
# Installs the NFS server software, allowing usage of the nfs::export
# resource type.
#
# === Parameters
#
# [*package*]
#   Corresponds to the ensure parameter of the Package resource type.
#
# [*service*]
#   Corresponds to the ensure parameter of the Service resource type.
#
# [*enable*]
#   Corresponds to the enable parameter of the Service resource type.
#
# === Variables
#
# This module requires no variables.
#
# === Examples
#
#  class { 'nfs::server':
#    package => installed,
#    service => running,
#    enable  => true,
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
class nfs::server (
    $package = installed,
    $service = running,
    $enable  = true,
) {

    require stdlib

    # TODO Refactor common packages, etc. out so that a server need not be a client as well.
    require nfs::client

    anchor { 'nfs::server::begin': }

    case $::operatingsystem {
        centos, redhat : {
            class { 'nfs::server::rhel':
                package => $package,
                service => $service,
                enable  => $enable,
            }
        }

        ubuntu, debian : {
            class { 'nfs::server::ubuntu':
                package => $package,
                service => $service,
                enable  => $enable,
            }
        }

        default : {
            fail("nfs::server is not currently supported on ${::operatingsystem}")
        }
    }

    anchor { 'nfs::server::end': }

}
