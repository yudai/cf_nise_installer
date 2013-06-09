# Cloud Foundry v2 Nise Installer

## Devbox Installer with Nise BOSH and nise-bosh-vagrant

CF Nise Installer is a set of scripts that install Cloud Foundry v2 instance to your single machine or Vagrant VM. You can build your 'devbox' quickly by runing a single command with this installer.

CF Nise Installer is based on [cf-release](https://github.com/cloudfoundry/cf-release) by Pivotal, [Nise BOSH](http://github.com/nttlabs/nise_bosh/) by NTT Laboratory and [nise-bosh-vagrant](https://github.com/BrianMMcClain/nise-bosh-vagrant) by Brian McClain.

## Build Devbox on Single Server

This section shows you how to install CF components to your server.

If you want to build a devbox on a Vagrant VM, skip this section and see the next section.

### Requirements

* Ubuntu 10.04 64bit
   * *Ubuntu 12.04 is not suported*
* 8GB+ free HDD space
* 4Gb+ memory
   * m1.large or larger instance is recommended on AWS

### Install Cloud Foundry Components

Run the commands below on your server:

```sh
sudo apt-get install curl
bash < <(curl -s -k -B https://raw.github.com/yudai/cf_nise_installer/master/scripts/local_bootstrap.sh)
```

The `bootstrap.sh` script installs everything needed for the devbox. This command may take a couple of hours at first run.

### Launch Processes

The `bootstrap.sh` script automatically start up the processes. You can target the Cloud Controller once the installation completes.

You can manually manage the processes for the devbox with the Monit which installed by Nise BOSH.

```sh
# Start Monit
sudo /var/vcap/bosh/bin/monit
# Launch `all` processes
sudo /var/vcap/bosh/bin/monit start all
# See status
sudo /var/vcap/bosh/bin/monit status
sudo /var/vcap/bosh/bin/monit summary # shorter
# Stop `all` processes
sudo /var/vcap/bosh/bin/monit stop all
```

Confirm all the processes shown by `monit summary` indicate `running`. It takes a few minutes to initialize all processes.

### Update Existing Devobox

You can update your existing devbox with the latest cf-release resources by executing `local_install.sh` script downloaded by the `bootstrap.sh` script.


### Customize Devbox

You can choose your cf-release repositry and its branch to install by setting environmental variables.

| Name              | Default                                        |
| :---------------: | :--------------------------------------------: |
| CF_RELEASE_URI    | https://github.com/cloudfoundry/cf-release.git |
| CF_RELEASE_BRANCH | master                                         |

These values are used only when no `cf-release` directory exists in the working directory. You can also put your prefered cf-release before running the script.

## Build Devbox with Vagrant

You can create a devbox VM quickly with Vagrant and [nise-bosh-vagrant](https://github.com/BrianMMcClain/nise-bosh-vagrant).

#### Requirements

* Vagrant 1.2 or later
* Ruby 1.9.3-p392 (Required by cf-release)
* 8GB+ free HDD space
* 4GB+ free memory

### Launch Vagrant VM

Run the following command:

```sh
sudo apt-get install curl
bash < <(curl -s -k -B https://raw.github.com/yudai/cf_nise_installer/master/scripts/vagrant_bootstrap.sh)
```

### Customize Devbox

You can choose your cf-release repositry and its branch to install by setting environmental variables. Additionally, you can configure the VMs which Vagrant creates.

| Name              | Default                                        |
| :---------------: | :--------------------------------------------: |
| CF_RELEASE_URI    | https://github.com/cloudfoundry/cf-release.git |
| CF_RELEASE_BRANCH | master                                         |
| BRIDGE_IP_ADDRESS | *nil*                                          |
| VAGRANT_MEMORY    | 4096                                           |


## Play with installed Devbox

You can target and login to your installed devbox using following values:


| Target URI     | api.\<IP Address\>.xip.io | api.192.168.10.10.xip.io |
| :------------: | :-----------------------: | :----------------------: |
| Admin User     | micro@vcap.me             | <-                       |
| Admin Password | micr0@micr0               | <-                       |

When you installed your devbox with Vagrant, you can access your devobx only from the host machine that runs the VM.

'[xip.io](http://xip.io/)' is a DNS service provided by 37signals that returns the IP address specified in the subdomain of FQDNs.

### Service token registration

To create services, you need to register tokens to UAA.

```sh
# login as an admin in advance
gem install admin-cf-plugin
cf create-service-auth-token --provider core --token token --label postgresql
cf create-service-auth-token --provider core --token token --label mysql
```

## Other resources

* [cf-vagrant-installer](https://github.com/Altoros/cf-vagrant-installer)
   * Another Chef-based vagrant project
