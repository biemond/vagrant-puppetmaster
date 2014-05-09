class portmap::debian (
    $package = installed,
    $service = running,
    $enable  = true,
) {

    anchor { 'portmap::debian::begin': }

    class { 'portmap::debian::packages':
        ensure => $package,
    } ->
    class { 'portmap::debian::config':
        ensure => $package,
    } ~>
    class { 'portmap::debian::services':
        ensure => $service,
        enable => $enable,
    }

    anchor { 'portmap::debian::end': }

}
