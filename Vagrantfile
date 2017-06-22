# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|
	config.vm.box = "debian/contrib-jessie64"
	config.vm.post_up_message = ""

	config.vm.hostname = "hsreplaynet.local"
	config.vm.network "forwarded_port", guest: 8000, host: 8000
	config.vm.network "forwarded_port", guest: 8443, host: 8443
	config.vm.network "forwarded_port", guest: 5432, host: 5432

	config.vm.synced_folder ".", "/home/vagrant/projects"

	config.vm.provision "shell",
		path: "scripts/provision_system.sh",
		keep_color: true

	config.vm.provider "virtualbox" do |v|
		v.memory = 2048
		v.cpus = 2
	end

	config.vm.provision "shell",
		path: "scripts/provision_user.sh",
		env: {"ENV_VAGRANT": "1", "HSREPLAYNET_DEBUG": "1"},
		privileged: false,
		keep_color: true
end
