class nfs::server::ubuntu::packages (
    $ensure = installed,
) {

    package { 'nfs-kernel-server':
        ensure => $ensure,
    }
}