require './.vagrant-provision-reboot-plugin'

Vagrant.configure("2") do |config|
  config.vm.box = "lucid64"
  config.vm.box_url = "http://files.vagrantup.com/lucid64.box"

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
  end

  config.vm.provision :shell do |shell|
    shell.inline = 'cd /vagrant && ./scripts/install.sh'
    shell.privileged = false
  end
  config.vm.provision :unix_reboot
  config.vm.provision :shell do |shell|
    shell.inline = 'cd /vagrant && ./scripts/start_processes.sh'
  end

end
