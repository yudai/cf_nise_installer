require './.vagrant-provision-reboot-plugin'

Vagrant.configure("2") do |config|
  config.vm.box = "lucid64"
  config.vm.box_url = "http://files.vagrantup.com/lucid64.box"

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
  end


  # Install newer Git to use relative paths in submodules' .git
  config.vm.provision :shell do |shell|
    shell.inline = 'apt-get update && apt-get -y install python-software-properties && add-apt-repository ppa:git-core/ppa'
  end
  # Run installer
  config.vm.provision :shell do |shell|
    shell.inline = 'cd /vagrant && ./scripts/install.sh'
    shell.privileged = false
  end
  # Reboot to reload the kernel
  config.vm.provision :unix_reboot
  # Start the processes
  config.vm.provision :shell do |shell|
    shell.inline = 'cd /vagrant && ./scripts/start_processes.sh'
    shell.privileged = false
  end

end
