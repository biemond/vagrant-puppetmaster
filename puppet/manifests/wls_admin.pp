node 'adminwls.example.com','adminwls2.example.com','adminwls3.example.com','adminwls4.example.com','adminwls5.example.com' {

  include os, ssh, java
  include orawls::weblogic, orautils
  include bsu
  include domains, nodemanager, startwls, userconfig
  include machines
  include managed_servers
  include clusters
  include file_persistence
  include jms_servers
  include jms_saf_agents
  include jms_modules
  include jms_module_subdeployments
  include jms_module_quotas
  include jms_module_cfs
  include jms_module_queues_objects
  include jms_module_topics_objects
  #include jms_module_foreign_server_objects,jms_module_foreign_server_entries_objects
  include pack_domain

  Class[java] -> Class[orawls::weblogic]
}  


class bsu{
  require orawls::weblogic
  $default_params = {}
  $bsu_instances = hiera('bsu_instances', {})
  create_resources('orawls::bsu',$bsu_instances, $default_params)
}

class fmw{
  require bsu
  $default_params = {}
  $fmw_installations = hiera('fmw_installations', {})
  create_resources('orawls::fmw',$fmw_installations, $default_params)
}

class opatch{
  require fmw,bsu,orawls::weblogic
  $default_params = {}
  $opatch_instances = hiera('opatch_instances', {})
  create_resources('orawls::opatch',$opatch_instances, $default_params)
}

class domains{
  require orawls::weblogic, opatch
  $default_params = {}
  $domain_instances = hiera('domain_instances', {})
  create_resources('orawls::domain',$domain_instances, $default_params)

  $domain_address = hiera('domain_adminserver_address')
  $domain_port    = hiera('domain_adminserver_port')

  wls_setting { 'default':
    user               => hiera('wls_os_user'),
    weblogic_home_dir  => hiera('wls_weblogic_home_dir'),
    connect_url        => "t3://${domain_address}:${domain_port}",
    weblogic_user      => hiera('wls_weblogic_user'),
    weblogic_password  => hiera('domain_wls_password'),
  }


}

class nodemanager {
  require orawls::weblogic, domains
  $default_params = {}
  $nodemanager_instances = hiera('nodemanager_instances', {})
  create_resources('orawls::nodemanager',$nodemanager_instances, $default_params)
}

class startwls {
  require orawls::weblogic, domains,nodemanager
  $default_params = {}
  $control_instances = hiera('control_instances', {})
  create_resources('orawls::control',$control_instances, $default_params)
}

class userconfig{
  require orawls::weblogic, domains, nodemanager, startwls 
  $default_params = {}
  $userconfig_instances = hiera('userconfig_instances', {})
  create_resources('orawls::storeuserconfig',$userconfig_instances, $default_params)
} 

class machines{
  require userconfig
  $default_params = {}
  $machines_instances = hiera('machines_instances', {})
  create_resources('wls_machine',$machines_instances, $default_params)
}


class managed_servers{
  require machines
  $default_params = {}
  $server_instances = hiera('server_instances', {})
  create_resources('wls_server',$server_instances, $default_params)
}

class datasources{
  require managed_servers
  $default_params = {}
  $datasource_instances = hiera('datasource_instances', {})
  create_resources('wls_datasource',$datasource_instances, $default_params)
}

class clusters{
  require managed_servers
  $default_params = {}
  $cluster_instances = hiera('cluster_instances', {})
  create_resources('wls_cluster',$cluster_instances, $default_params)
}

class file_persistence{
  require clusters
  $default_params = {}
  $file_persistence = hiera('file_persistence_store_instances', {})
  create_resources('wls_file_persistence_store',$file_persistence, $default_params)
}

class jms_servers{
  require file_persistence
  $default_params = {}
  $jms_servers_instances = hiera('jmsserver_instances', {})
  create_resources('wls_jmsserver',$jms_servers_instances, $default_params)
}

class jms_saf_agents{
  require jms_servers
  $default_params = {}
  $jms_saf_agents_instances = hiera('safagent_instances', {})
  create_resources('wls_safagent',$jms_saf_agents_instances, $default_params)
}

class jms_modules{
  require jms_saf_agents
  $default_params = {}
  $jms_modules_instances = hiera('jms_modules_instances', {})
  create_resources('wls_jms_module',$jms_modules_instances, $default_params)
}

class jms_module_subdeployments{
  require jms_modules
  $default_params = {}
  $jms_subdeployments_instances = hiera('jms_subdeployments_instances', {})
  create_resources('wls_jms_subdeployment',$jms_subdeployments_instances, $default_params)
}

class jms_module_quotas{
  require jms_module_subdeployments
  $default_params = {}
  $jms_quotas_instances = hiera('jms_quotas_instances', {})
  create_resources('wls_jms_quota',$jms_quotas_instances, $default_params)
}

class jms_module_cfs{
  require jms_module_quotas
  $default_params = {}
  $jms_cf_instances = hiera('jms_cf_instances', {})
  create_resources('wls_jms_connection_factory',$jms_cf_instances, $default_params)
}


class jms_module_queues_objects{
  require jms_module_cfs
  $default_params = {}
  $jms_queues_instances = hiera('jms_queues_instances', {})
  create_resources('wls_jms_queue',$jms_queues_instances, $default_params)
}

class jms_module_topics_objects{
  require jms_module_queues_objects
  $default_params = {}
  $jms_topics_instances = hiera('jms_topics_instances', {})
  create_resources('wls_jms_topic',$jms_topics_instances, $default_params)
}


# class jms_module_foreign_server_objects{
#   require jms_module_topics_objects
#   $default_params = {}
#   $jms_foreign_server_instances = hiera('jms_foreign_server_instances', {})
#   create_resources('orawls::wlstexec',$jms_foreign_server_instances, $default_params)
# }

# class jms_module_foreign_server_entries_objects{
#   require jms_module_foreign_server_objects
#   $default_params = {}
#   $jms_foreign_server_objects_instances = hiera('jms_foreign_server_objects_instances', {})
#   create_resources('orawls::wlstexec',$jms_foreign_server_objects_instances, $default_params)
# }

class pack_domain{
  require jms_module_topics_objects
  $default_params = {}
  $pack_domain_instances = hiera('pack_domain_instances', $default_params)
  create_resources('orawls::packdomain',$pack_domain_instances, $default_params)
}


