require './.vagrant-provision-reboot-plugin'

NISE_IP_ADDRESS = "10.39.39.39"

Vagrant.configure("2") do |config|
  config.vm.box = "trusty64"
  config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"

  config.vm.network :private_network, ip: NISE_IP_ADDRESS

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
  end


  # Install newer Git to use relative paths in submodules' .git
  config.vm.provision :shell do |shell|
    shell.inline = 'apt-get update && apt-get -y install python-software-properties && add-apt-repository ppa:git-core/ppa'
  end
  # Run installer
  config.vm.provision :shell do |shell|
    shell.inline = "cd /vagrant && NISE_IP_ADDRESS=#{NISE_IP_ADDRESS} ./scripts/install.sh"
    shell.privileged = false
  end
  # Reboot to reload the kernel
  config.vm.provision :unix_reboot
  # Start the processes
  config.vm.provision :shell do |shell|
    shell.inline = 'cd /vagrant && ./scripts/start.sh'
    shell.privileged = false
  end

end
