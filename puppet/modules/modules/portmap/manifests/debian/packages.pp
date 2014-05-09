class portmap::debian::packages (
    $ensure = installed,
) {

    $packages = $::lsbdistcodename ? {
        'lucid' => 'portmap',
        default => 'rpcbind',
    }

    package { $packages:
        ensure => $ensure,
    }

}
