# == Class oracle::params
#
# This class is meant to be called from oracle
# It sets variables according to platform
#
class oracle::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'oracle'
      $service_name = 'oracle'
    }
    'RedHat', 'Amazon': {
      $package_name = 'oracle'
      $service_name = 'oracle'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
