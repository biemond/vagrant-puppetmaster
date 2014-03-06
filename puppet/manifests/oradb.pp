
node 'oradb.example.com' {
   include oradb_os
   include goldengate_11g
   include oradb_11g
   include oradb_maintenance
   #include oradb_configuration
} 


class oradb_11g {
  require oradb_os

    oradb::installdb{ '11.2_linux-x64':
            version                => '11.2.0.4',
            file                   => 'p13390677_112040_Linux-x86-64',
            databaseType           => 'SE',
            oracleBase             => hiera('oracle_base_dir'),
            oracleHome             => hiera('oracle_home_dir'),
            userBaseDir            => '/home',
            createUser             => false,
            user                   => hiera('oracle_os_user'),
            group                  => hiera('oracle_os_group'),
            downloadDir            => hiera('oracle_download_dir'),
            remoteFile             => true,
            puppetDownloadMntPoint => hiera('oracle_source'),  
    }

   oradb::net{ 'config net8':
            oracleHome   => hiera('oracle_home_dir'),
            version      => hiera('oracle_version'),
            user         => hiera('oracle_os_user'),
            group        => hiera('oracle_os_group'),
            downloadDir  => hiera('oracle_download_dir'),
            require      => Oradb::Installdb['11.2_linux-x64'],
   }

   oradb::listener{'start listener':
            oracleBase   => hiera('oracle_base_dir'),
            oracleHome   => hiera('oracle_home_dir'),
            user         => hiera('oracle_os_user'),
            group        => hiera('oracle_os_group'),
            action       => 'start',  
            require      => Oradb::Net['config net8'],
   }

   # alter system set xxx scope= spfile|both 
   # enable_goldengate_replication=true,undo_management=auto,undo_retention=86400
   oradb::database{ 'oraDb': 
                    oracleBase              => hiera('oracle_base_dir'),
                    oracleHome              => hiera('oracle_home_dir'),
                    version                 => hiera('oracle_version'),
                    user                    => hiera('oracle_os_user'),
                    group                   => hiera('oracle_os_group'),
                    downloadDir             => hiera('oracle_download_dir'),
                    action                  => 'create',
                    dbName                  => hiera('oracle_database_name'),
                    dbDomain                => hiera('oracle_database_domain_name'),
                    sysPassword             => hiera('oracle_database_sys_password'),
                    systemPassword          => hiera('oracle_database_system_password'),
                    dataFileDestination     => "/oracle/oradata",
                    recoveryAreaDestination => "/oracle/flash_recovery_area",
                    characterSet            => "AL32UTF8",
                    nationalCharacterSet    => "UTF8",
                    initParams              => "open_cursors=1000,processes=600,job_queue_processes=4,compatible='11.2.0.4'",
                    sampleSchema            => 'TRUE',
                    memoryPercentage        => "40",
                    memoryTotal             => "800",
                    databaseType            => "MULTIPURPOSE",                         
                    require                 => Oradb::Listener['start listener'],
   }

   oradb::dbactions{ 'start oraDb': 
                   oracleHome              => hiera('oracle_home_dir'),
                   user                    => hiera('oracle_os_user'),
                   group                   => hiera('oracle_os_group'),
                   action                  => 'start',
                   dbName                  => hiera('oracle_database_name'),
                   require                 => Oradb::Database['oraDb'],
   }

   oradb::autostartdatabase{ 'autostart oracle': 
                   oracleHome              => hiera('oracle_home_dir'),
                   user                    => hiera('oracle_os_user'),
                   dbName                  => hiera('oracle_database_name'),
                   require                 => Oradb::Dbactions['start oraDb'],
   }

  oradb::rcu{  'DEV_PS6':
                 rcuFile          => 'ofm_rcu_linux_11.1.1.7.0_64_disk1_1of1.zip',
                 product          => hiera('repository_type'),
                 version          => '11.1.1.7',
                 user             => hiera('oracle_os_user'),
                 group            => hiera('oracle_os_group'),
                 downloadDir      => hiera('oracle_download_dir'),
                 action           => 'create',
                 oracleHome       => hiera('oracle_home_dir'),
                 dbServer         => hiera('oracle_database_host'),
                 dbService        => hiera('oracle_database_service_name'),
                 sysPassword      => hiera('oracle_database_sys_password'),
                 schemaPrefix     => hiera('repository_prefix'),
                 reposPassword    => hiera('repository_password'),
                 tempTablespace   => 'TEMP',
                 puppetDownloadMntPoint => hiera('oracle_source'), 
                 remoteFile       => true,
                 logoutput        => true,
                 require          => Oradb::Dbactions['start oraDb'],
  }


}

class goldengate_11g {
   require oradb_11g

      file { "/oracle/product" :
        ensure        => directory,
        recurse       => false,
        replace       => false,
        mode          => 0775,
        owner         => hiera('oracle_os_user'),
        group         => hiera('oracle_os_group'),
      }

      file { "/oracle/product/12.1.2" :
        ensure        => directory,
        recurse       => false,
        replace       => false,
        mode          => 0775,
        owner         => 'ggate',
        group         => hiera('oracle_os_group'),
      }

      oradb::goldengate{ 'ggate12.1.2':
                         version                 => '12.1.2',
                         file                    => '121200_fbo_ggs_Linux_x64_shiphome.zip',
                         databaseType            => 'Oracle',
                         databaseVersion         => 'ORA11g',
                         databaseHome            => hiera('oracle_home_dir'),
                         oracleBase              => hiera('oracle_base_dir'),
                         goldengateHome          => "/oracle/product/12.1.2/ggate",
                         managerPort             => 16000,
                         user                    => hiera('ggate_os_user'),
                         group                   => hiera('oracle_os_group'),
                         downloadDir             => '/install',
                         puppetDownloadMntPoint  =>  hiera('oracle_source'),
                         require                 => [File["/oracle/product"],File["/oracle/product/12.1.2"]]
      }

      file { "/oracle/product/12.1.2/ggate/OPatch" :
        ensure        => directory,
        recurse       => true,
        replace       => false,
        mode          => 0775,
        owner         => hiera('ggate_os_user'),
        group         => hiera('oracle_os_group'),
        require       => Oradb::Goldengate['ggate12.1.2'],
      }
}

class oradb_configuration {
  require oradb_11g

  tablespace {'scott_ts':
    ensure                    => present,
    size                      => 100M,
    logging                   => yes,
    autoextend                => on,
    next                      => 100M,
    max_size                  => 12288M,
    extent_management         => local,
    segment_space_management  => auto,
  }

  role {'apps':
    ensure    => present,
  }

  oracle_user{'scott':
    temporary_tablespace      => temp,
    default_tablespace        => 'scott_ts',
    password                  => 'tiger',
    grants                    => ['SELECT ANY TABLE',
                                  'CONNECT',
                                  'RESOURCE',
                                  'apps'],
    quotas                    => { "scott_ts" => 'unlimited'},
    require                   => [Tablespace['scott_ts'],
                                  Role['apps']],
  }


}


class oradb_maintenance {
  require oradb_11g

  case $operatingsystem {
    CentOS, RedHat, OracleLinux, Ubuntu, Debian: { 
      $mtimeParam = "1"
    }
    Solaris: { 
      $mtimeParam = "+1"
    }
  }

  cron { 'oracle_db_opatch' :
    command => "find /oracle/product/11.2/db/cfgtoollogs/opatch -name 'opatch*.log' -mtime ${mtimeParam} -exec rm {} \\; >> /tmp/opatch_db_purge.log 2>&1",
    user    => oracle,
    hour    => 06,
    minute  => 34,
  }
  
  cron { 'oracle_db_lsinv' :
    command => "find /oracle/product/11.2/db/cfgtoollogs/opatch/lsinv -name 'lsinventory*.txt' -mtime ${mtimeParam} -exec rm {} \\; >> /tmp/opatch_lsinv_db_purge.log 2>&1",
    user    => oracle,
    hour    => 06,
    minute  => 32,
  }
}

