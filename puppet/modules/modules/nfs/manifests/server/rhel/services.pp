class nfs::server::rhel::services (
    $ensure = running,
    $enable = true,
) {

    require portmap

    service { 'nfs':
        ensure     => $ensure,
        enable     => $enable,
        hasstatus  => true,
        hasrestart => true,
    }

    service { 'nfslock':
        ensure     => $ensure,
        enable     => $enable,
        hasstatus  => true,
        hasrestart => true,
    }

}
