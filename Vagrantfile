# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/bionic64"
  config.vm.network "forwarded_port", guest: 25565, host: 25565
  config.vm.network "public_network"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "8192"
    vb.cpus = "2"
  end
  config.vm.provision "shell", inline: <<-SHELL
    git clone https://github.com/claudefunston/mc_auto_setup
    sudo chown vagrant /home/vagrant/mc_auto_setup
    sudo chgrp vagrant /home/vagrant/mc_auto_setup
  SHELL
end
