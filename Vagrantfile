# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define :master do |master_config|

    if Vagrant.has_plugin?("vagrant-cachier")
      config.cache.auto_detect = true
    end

    master_config.vm.hostname = "puppet.grahamgilbert.dev"
    master_config.vm.box      = "precise64"
    master_config.vm.box_url  = "http://files.vagrantup.com/precise64.box"
  
    master_config.vm.network :private_network, ip: "10.10.10.2"

    master_config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1532"]
      vb.customize ["modifyvm", :id, "--name", "puppet"]
    end
    
    master_config.vm.provision :shell, :path => "puppet_master.sh"

    master_config.vm.provision :puppet, :module_path => "VagrantConf/modules", :manifests_path => "VagrantConf/manifests", :manifest_file  => "default.pp"

    master_config.vm.synced_folder "puppet/manifests", "/etc/puppet/manifests"
    master_config.vm.synced_folder "puppet/modules"  , "/etc/puppet/modules"
    master_config.vm.synced_folder "puppet/hieradata", "/etc/puppet/hieradata"

    master_config.vm.synced_folder "/Users/edwin/software", "/software", type: "nfs"


  end
  
  
end
