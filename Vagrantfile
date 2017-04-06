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
     sudo mkdir -p /opt/vault/data
     cd /opt/vault
     sudo unzip /tmp/vault*zip
     /opt/vault/vault -v

    sudo cp /vagrant/t/.files/vault.hcl /opt/vault/vault.hcl
    sudo cp /vagrant/t/.files/vault.service /lib/systemd/system/vault.service
    sudo cp /vagrant/t/.files/vault.sh /etc/profile.d/vault.sh

    sudo systemctl daemon-reload
    sudo systemctl start vault
    sudo systemctl enable vault

    # finish up
    # sudo /vagrant/src/server/DEBIAN/postinst
   SHELL
end
