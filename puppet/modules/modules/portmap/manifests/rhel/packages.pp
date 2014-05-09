class portmap::rhel::packages (
    $ensure = installed,
) {

    $packages = $::operatingsystemmajrelease ? {
        5 => 'portmap',
        6 => 'rpcbind',
    }

    package { $packages:
        ensure => $ensure,
    }

}
