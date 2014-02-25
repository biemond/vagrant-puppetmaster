# == Class: oracle
#
# Full description of class oracle here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class oracle (
) inherits oracle::params {

  # validate parameters here

  class { 'oracle::install': } ->
  class { 'oracle::config': } ~>
  class { 'oracle::service': } ->
  Class['oracle']
}
