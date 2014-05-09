class portmap::rhel (
    $package = installed,
    $service = running,
    $enable  = true,
) {

    anchor { 'portmap::rhel::begin': }

    class { 'portmap::rhel::packages':
        ensure => $package,
    } ->
    class { 'portmap::rhel::services':
        ensure => $service,
        enable => $enable,
    }

    anchor { 'portmap::rhel::end': }

}
