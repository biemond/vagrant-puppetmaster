# operating settings for Middleware
class os {

  $host_instances = hiera('hosts', [])
  create_resources('host',$host_instances)

  exec { "create swap file":
    command => "/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=8192",
    creates => "/var/swap.1",
  }

  exec { "attach swap file":
    command => "/sbin/mkswap /var/swap.1 && /sbin/swapon /var/swap.1",
    require => Exec["create swap file"],
    unless => "/sbin/swapon -s | grep /var/swap.1",
  }

  #add swap file entry to fstab
  exec {"add swapfile entry to fstab":
    command => "/bin/echo >>/etc/fstab /var/swap.1 swap swap defaults 0 0",
    require => Exec["attach swap file"],
    user => root,
    unless => "/bin/grep '^/var/swap.1' /etc/fstab 2>/dev/null",
  }

  service { iptables:
        enable    => false,
        ensure    => false,
        hasstatus => true,
  }

  group { 'dba' :
    ensure => present,
  }

  # http://raftaman.net/?p=1311 for generating password
  # password = oracle
  user { 'oracle' :
    ensure     => present,
    groups     => 'dba',
    shell      => '/bin/bash',
    password   => '$1$DSJ51vh6$4XzzwyIOk6Bi/54kglGk3.',
    home       => "/home/oracle",
    comment    => 'oracle user created by Puppet',
    managehome => true,
    require    => Group['dba'],
  }

  $install = [ 'binutils.x86_64','unzip.x86_64']


  package { $install:
    ensure  => present,
  }

  class { 'limits':
    config => {
               '*'       => {  'nofile'  => { soft => '2048'   , hard => '8192',   },},
               'wls'     => {  'nofile'  => { soft => '65536'  , hard => '65536',  },
                               'nproc'   => { soft => '2048'   , hard => '16384',   },
                               'memlock' => { soft => '1048576', hard => '1048576',},
                               'stack'   => { soft => '10240'  ,},},
               },
    use_hiera => false,
  }

  sysctl { 'kernel.msgmnb':                 ensure => 'present', permanent => 'yes', value => '65536',}
  sysctl { 'kernel.msgmax':                 ensure => 'present', permanent => 'yes', value => '65536',}
  sysctl { 'kernel.shmmax':                 ensure => 'present', permanent => 'yes', value => '2588483584',}
  sysctl { 'kernel.shmall':                 ensure => 'present', permanent => 'yes', value => '2097152',}
  sysctl { 'fs.file-max':                   ensure => 'present', permanent => 'yes', value => '6815744',}
  sysctl { 'net.ipv4.tcp_keepalive_time':   ensure => 'present', permanent => 'yes', value => '1800',}
  sysctl { 'net.ipv4.tcp_keepalive_intvl':  ensure => 'present', permanent => 'yes', value => '30',}
  sysctl { 'net.ipv4.tcp_keepalive_probes': ensure => 'present', permanent => 'yes', value => '5',}
  sysctl { 'net.ipv4.tcp_fin_timeout':      ensure => 'present', permanent => 'yes', value => '30',}
  sysctl { 'kernel.shmmni':                 ensure => 'present', permanent => 'yes', value => '4096', }
  sysctl { 'fs.aio-max-nr':                 ensure => 'present', permanent => 'yes', value => '1048576',}
  sysctl { 'kernel.sem':                    ensure => 'present', permanent => 'yes', value => '250 32000 100 128',}
  sysctl { 'net.ipv4.ip_local_port_range':  ensure => 'present', permanent => 'yes', value => '9000 65500',}
  sysctl { 'net.core.rmem_default':         ensure => 'present', permanent => 'yes', value => '262144',}
  sysctl { 'net.core.rmem_max':             ensure => 'present', permanent => 'yes', value => '4194304', }
  sysctl { 'net.core.wmem_default':         ensure => 'present', permanent => 'yes', value => '262144',}
  sysctl { 'net.core.wmem_max':             ensure => 'present', permanent => 'yes', value => '1048576',}

}

# operating settings for Database & Middleware
class oradb_os {

  $host_instances = hiera('hosts', [])
  create_resources('host',$host_instances)


  service { iptables:
    enable    => false,
    ensure    => false,
    hasstatus => true,
  }

  group { 'dba' :
    ensure      => present,
  }

  user { 'oracle' :
    ensure      => present,
    gid         => 'dba',  
    groups      => 'dba',
    shell       => '/bin/bash',
    password    => '$1$DSJ51vh6$4XzzwyIOk6Bi/54kglGk3.',
    home        => "/home/oracle",
    comment     => "This user oracle was created by Puppet",
    require     => Group['dba'],
    managehome  => true,
  }

  user { 'ggate' :
    ensure      => present,
    gid         => 'dba',  
    groups      => 'dba',
    shell       => '/bin/bash',
    password    => '$1$DSJ51vh6$4XzzwyIOk6Bi/54kglGk3.',
    home        => "/home/ggate",
    comment     => "This user ggate was created by Puppet",
    require     => Group['dba'],
    managehome  => true,
  }

  $install = [ 'binutils.x86_64', 'compat-libstdc++-33.x86_64', 'glibc.x86_64','ksh.x86_64','libaio.x86_64',
               'libgcc.x86_64', 'libstdc++.x86_64', 'make.x86_64','compat-libcap1.x86_64', 'gcc.x86_64',
               'gcc-c++.x86_64','glibc-devel.x86_64','libaio-devel.x86_64','libstdc++-devel.x86_64',
               'sysstat.x86_64','unixODBC-devel','glibc.i686','libXext.i686','libXtst.i686']
       

  package { $install:
    ensure  => present,
  }

  class { 'limits':
         config => {
                    '*'       => { 'nofile'  => { soft => '2048'   , hard => '8192',   },},
                    'oracle'  => { 'nofile'  => { soft => '65536'  , hard => '65536',  },
                                    'nproc'  => { soft => '2048'   , hard => '16384',  },
                                    'stack'  => { soft => '10240'  ,},},
                    },
         use_hiera => false,
  }
 
  sysctl { 'kernel.msgmnb':                 ensure => 'present', permanent => 'yes', value => '65536',}
  sysctl { 'kernel.msgmax':                 ensure => 'present', permanent => 'yes', value => '65536',}
  sysctl { 'kernel.shmmax':                 ensure => 'present', permanent => 'yes', value => '2588483584',}
  sysctl { 'kernel.shmall':                 ensure => 'present', permanent => 'yes', value => '2097152',}
  sysctl { 'fs.file-max':                   ensure => 'present', permanent => 'yes', value => '6815744',}
  sysctl { 'net.ipv4.tcp_keepalive_time':   ensure => 'present', permanent => 'yes', value => '1800',}
  sysctl { 'net.ipv4.tcp_keepalive_intvl':  ensure => 'present', permanent => 'yes', value => '30',}
  sysctl { 'net.ipv4.tcp_keepalive_probes': ensure => 'present', permanent => 'yes', value => '5',}
  sysctl { 'net.ipv4.tcp_fin_timeout':      ensure => 'present', permanent => 'yes', value => '30',}
  sysctl { 'kernel.shmmni':                 ensure => 'present', permanent => 'yes', value => '4096', }
  sysctl { 'fs.aio-max-nr':                 ensure => 'present', permanent => 'yes', value => '1048576',}
  sysctl { 'kernel.sem':                    ensure => 'present', permanent => 'yes', value => '250 32000 100 128',}
  sysctl { 'net.ipv4.ip_local_port_range':  ensure => 'present', permanent => 'yes', value => '9000 65500',}
  sysctl { 'net.core.rmem_default':         ensure => 'present', permanent => 'yes', value => '262144',}
  sysctl { 'net.core.rmem_max':             ensure => 'present', permanent => 'yes', value => '4194304', }
  sysctl { 'net.core.wmem_default':         ensure => 'present', permanent => 'yes', value => '262144',}
  sysctl { 'net.core.wmem_max':             ensure => 'present', permanent => 'yes', value => '1048576',}

}


class ssh {
  require os

  file { "/home/oracle/.ssh/":
    owner  => "oracle",
    group  => "dba",
    mode   => "700",
    ensure => "directory",
    alias  => "oracle-ssh-dir",
  }

  file { "/home/oracle/.ssh/id_rsa.pub":
    ensure  => present,
    owner   => "oracle",
    group   => "dba",
    mode    => "644",
    source  => "puppet:///middleware/ssh/id_rsa.pub",
    require => File["oracle-ssh-dir"],
  }

  file { "/home/oracle/.ssh/id_rsa":
    ensure  => present,
    owner   => "oracle",
    group   => "dba",
    mode    => "600",
    source  => "puppet:///middleware/ssh/id_rsa",
    require => File["oracle-ssh-dir"],
  }

  file { "/home/oracle/.ssh/authorized_keys":
    ensure  => present,
    owner   => "oracle",
    group   => "dba",
    mode    => "644",
    source  => "puppet:///middleware/ssh/id_rsa.pub",
    require => File["oracle-ssh-dir"],
  }        
}

class java {
  require os

  $remove = [ "java-1.7.0-openjdk.x86_64", "java-1.6.0-openjdk.x86_64" ]

  package { $remove:
    ensure  => absent,
  }

  include jdk7

  jdk7::install7{ 'jdk1.7.0_51':
      version              => "7u51" , 
      fullVersion          => "jdk1.7.0_51",
      alternativesPriority => 18000, 
      x64                  => true,
      downloadDir          => "/data/install",
      urandomJavaFix       => true,
      sourcePath           => "puppet:///middleware/",
  }

}