class nfs::server::ubuntu::services (
    $ensure = running,
    $enable = true,
) {

    require portmap

    service { 'nfs-kernel-server':
        ensure     => $ensure,
        enable     => $enable,
        hasstatus  => true,
        hasrestart => true,
    }
}