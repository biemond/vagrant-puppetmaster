# == Class oracle::install
#
class oracle::install {
  include oracle::params

  package { $oracle::params::package_name:
    ensure => present,
  }
}
