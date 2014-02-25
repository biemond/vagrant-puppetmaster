# == Class oracle::service
#
# This class is meant to be called from oracle
# It ensure the service is running
#
class oracle::service {
  include oracle::params

  service { $oracle::params::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
