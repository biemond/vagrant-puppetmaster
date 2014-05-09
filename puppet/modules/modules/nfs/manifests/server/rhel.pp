class nfs::server::rhel (
    $package = installed,
    $service = running,
    $enable  = true,
) {

    anchor { 'nfs::server::rhel::begin': }

    class { 'nfs::server::rhel::config':
        ensure => $package,
    } ~>
    class { 'nfs::server::rhel::services':
        ensure => $service,
        enable => $enable,
    }

    anchor { 'nfs::server::rhel::end': }

}
