class portmap::debian::services (
    $ensure = running,
    $enable = true,
) {

    # FIXME I assume I'll need to do something with idmapd

    case $::lsbdistid  {
      /(ubuntu|Ubuntu)/ : {
        case $::lsbdistrelease {
          13.10 : {
            $services = 'rpcbind'
          }
          14.04 : {
            $services = 'rpcbind'
          }
          default : {
            $services = 'portmap'
          }
        }
      }
      /(debian|Debian)/ : {
        case $::lsbmajdistrelease {
          7 : {
            $services = 'rpcbind'
          }
          default : {
            $services = 'portmap'
          }
        }
      }
    }

    service { $services:
        ensure => $ensure,
        enable => $enable,
    }
}
