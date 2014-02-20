require './.vagrant-provision-reboot-plugin'

Vagrant.configure("2") do |config|
  config.vm.box = "lucid64"

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
  end

  config.vm.provision :shell do |shell|
    shell.inline = 'cd /vagrant && ./local/install.sh'
    shell.privileged = false
  end
  config.vm.provision :unix_reboot
  config.vm.provision :shell do |shell|
    shell.inline = 'cd /vagrant && ./local/start_processes.sh'
  end

end
