VAGRANTFILE_API_VERSION = "2"

  Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    config.vm.box = "hashicorp/precise64"

    config.vm.provider "virtualbox" do |v|
        v.memory = 2048
    end

    # enable private access to the machine via a static ip address
    config.vm.network "private_network", ip: "10.0.0.2"

    # Share current folder in /vagrant
    config.vm.synced_folder ".", "/vagrant", type: "nfs"
    config.vm.synced_folder "/Users/dvd/Taktik/openerp/modules", "/modules", type: "nfs"

    # update package list, install some packages & build custom docker image
    config.vm.provision :shell, :path => "vagrant_bootstrap.sh"

    config.vm.network "forwarded_port", guest: 8069, host: 8888
    config.vm.network "forwarded_port", guest: 5432, host: 5454

  end
