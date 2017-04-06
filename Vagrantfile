# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "debian/jessie64"

  config.vm.synced_folder '.', '/vagrant'
  #config.vm.synced_folder '.', '/vagrant_data'

  config.vm.provision "shell", inline: <<-SHELL

     # install what we need
     sudo apt-get update
     sudo apt-get install unzip
     cd /tmp
     wget --no-check-certificate https://releases.hashicorp.com/vault/0.7.0/vault_0.7.0_linux_amd64.zip
     sudo mkdir -p /opt/vault
     cd /opt/vault
     sudo unzip /tmp/vault*zip
     /opt/vault/vault -v

    # finish up
    # sudo /vagrant/src/server/DEBIAN/postinst
   SHELL
end
