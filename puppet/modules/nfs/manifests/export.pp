define nfs::export (
    $path    = $name,
    $options = [ 'rw', 'sync', 'no_subtree_check', ],
    $clients,
) {

    concat::fragment { $name:
        target  => '/etc/exports',
        content => template('nfs/exports.fragment.erb'),
    }

}
