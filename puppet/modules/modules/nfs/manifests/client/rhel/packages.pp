class nfs::client::rhel::packages (
    $ensure = installed,
) {

    package { 'nfs-utils':
        ensure => $ensure,
    }

    package { 'nfs-utils-lib':
        ensure => $ensure,
    }

}
