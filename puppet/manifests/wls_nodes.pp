node 'nodewls1.example.com','nodewls2.example.com' {

  include os, ssh, java, orawls::weblogic, bsu_nodes, orautils, copydomain_nodes, nodemanager_nodes
  Class['java'] -> Class['orawls::weblogic'] 
}

class bsu_nodes {
  require orawls::weblogic
  $default_params = {}
  $bsu_instances = hiera('bsu_instances', [])
  create_resources('orawls::bsu',$bsu_instances, $default_params)
}

class copydomain_nodes {
  require orawls::weblogic, bsu_nodes
  $default_params = {}
  $copy_instances = hiera('copy_instances', [])
  create_resources('orawls::copydomain',$copy_instances, $default_params)
}

class nodemanager_nodes {
  require orawls::weblogic, bsu_nodes, copydomain_nodes
  $default_params = {}
  $nodemanager_instances = hiera('nodemanager_instances', [])
  create_resources('orawls::nodemanager',$nodemanager_instances, $default_params)
}