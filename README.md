# Cloud Foundry v2 Nise Installer

## Devbox Installer with Nise BOSH and nise-bosh-vagrant

CF Nise Installer is a set of scripts that installs a Cloud Foundry v2 instance to your single machine or Vagrant VM. You can build your own 'devbox' quickly by running a single command with this installer.

CF Nise Installer is based on [cf-release](https://github.com/cloudfoundry/cf-release) by Pivotal, [Nise BOSH](http://github.com/nttlabs/nise_bosh/) by NTT Laboratory and [nise-bosh-vagrant](https://github.com/BrianMMcClain/nise-bosh-vagrant) by Brian McClain.

### *NOTICE*

This installer is mainly for testing installation with BOSH. If you just want to try Cloud Foundry, [cf-vagrant-installer](https://github.com/Altoros/cf-vagrant-installer) may be a better solution for you.


### *NOTICE*

The services have been removed from cf-release. [Use an older snapshot branch when you need services](https://github.com/yudai/cf_nise_installer/tree/snapshot-ea61ec6f8f).

## Building Devbox on Single Server

This section shows you how to install CF components to your server.

If you want to build a devbox on a Vagrant VM, skip this section and see the next section.

### Requirements

* Ubuntu 10.04 64bit
   * *Ubuntu 12.04 is not supported*
* 8GB+ free HDD space
* 4GB+ memory
   * m1.medium or larger instance is recommended on AWS

### Installing Cloud Foundry Components

Run the commands below on your server:

```sh
sudo apt-get install curl
bash < <(curl -s -k -B https://raw.github.com/yudai/cf_nise_installer/${INSTALLER_BRANCH:-master}/local/bootstrap.sh)
```

The `bootstrap.sh` script installs everything needed for your devbox. This command may take a couple of hours at first run.

You need to restart your server once after the installation is completed.

### Launching Processes

You can start the processes for your devbox by running the following command in the `cf_nise_installer` directory cloned by the `bootstrap.sh` script:

```sh
./local/start_processes.sh
```

This command launches the Monit process and then start up all monit jobs installed by Nise BOSH.

You can also manually manage the processes with the Monit command:

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

### Update Existing Devbox

To update your existing Devbox, you can use scripts in the `local` directory. You don't need to execute the `bootstrap.sh` script for this purpose.

* clone_cf_release.sh
  * Clones `cf-release` repository
  * When the `cf-release` directory exists, does nothing.
* launch_nise_bosh.sh
  * Executes Nise BOSH and update installation
* postinstall.sh
  * Runs some commands to work the CF instance properly
  * Required to be executed after the `launch_nise_bosh.sh`
* start_processes.sh
  * Invokes the Monit process and CF processes
* register_service_tokens.sh
  * Registers required tokens for services
  * Required to be executed *once* after launching processes
* install.sh
  * Runs the above scripts in order
  * Executes some additional tasks such as installing Ruby, Gems and Nise Bosh


When run these scrips, be sure your are  in the `cf_nise_installer` directory, and not in `local` directory.

#### Notes for Updating Devbox

These scripts do *not* automatically update existing files in the working directory.

You need to delete the `cf_nise_installer` directory created by the `bootstrap.sh` script to apply changes on environment variables below and other modification in outer repositories such as `cf-release`. You are alwo able to manually edit files in the directory and run `install.sh` or each script required to install.


### Environment Variables

You can customize your installation using environment variables.

| Name              | Description                              | Used in                                 | Default                                        |
| :---------------: | :--------------------------------------: | :-------------------------------------: | :--------------------------------------------: |
| INSTALLER_URL     | URI for cf_nise_installer                | bootstrap.sh                            | https://github.com/yudai/cf_nise_installer.git |
| INSTALLER_BRANCH  | Branch/Revision for cf_nise_installer    | bootstrap.sh                            | master                                         |
| CF_RELEASE_URL    | URI for cf-release | clone_cf_release.sh | clone_cf_release.sh                     | https://github.com/cloudfoundry/cf-release.git |
| CF_RELEASE_BRANCH | Branch/Revision for cf-release           | clone_cf_release.sh                     | master                                         |
| CF_RELEASE_USE_HEAD | Create a dev release with the head of the branch | clone_cf_release.sh                     | no (set `yes` to enable)                        |
| NISE_IP_ADDRESS   | IP address to bind CF components         | install.sh, register_service_tokens.sh  | Automatically detected using `ip` command      |
| NISE_DOMAIN       | Domain name for the devbox               | launch_nise_bosh.sh                     | *nil* (<ip_address>.xip.io)                    |

## Build Devbox with Vagrant

You can create a devbox VM quickly with Vagrant and [nise-bosh-vagrant](https://github.com/BrianMMcClain/nise-bosh-vagrant).

#### Requirements

* Vagrant 1.2 or later
* Ruby 1.9.3-p448 (Required by cf-release)
* 8GB+ free HDD space
* 4GB+ free memory

### Launch Vagrant VM with CF components

Run the following command:

```sh
sudo apt-get install curl
bash < <(curl -s -k -B https://raw.github.com/yudai/cf_nise_installer/${INSTALLER_BRANCH:-master}/vagrant/bootstrap.sh)
```
Once the command is finished, you can target your devbox and push applications.

### Updating Devbox

To update your existing devbox, you can use scripts in the `vagrant` directory.

* clone_cf_release.sh
  * Clones `cf-release` repository
  * When the `cf-release` directory exists, does *nothing*.
* launch_nise_bosh.sh
  * Launch a new Vagrant VM and executes Nise BOSH in the VM
  * Destroy the existing VM before running this script
* postinstall.sh
  * Runs some commands to work the CF instance properly
  * Required to be executed after the `launch_nise_bosh.sh`
* start_processes.sh
  * Invokes the Monit process and CF processes
* register_service_tokens.sh
  * Registers required tokens for services
  * Required to be executed *once* after launching processes
* install.sh
  * Runs the above scripts in order

When run these scripts, be sure your are  in the `cf_nise_installer` directory, and not in `vagrant` directory.

You can destroy your existing VM and delete generated files with the following commands:

```sh
cd cf-release
vagrant destroy && rm -rf .nise-bosh-* Vagrantfile .vagrant
```

When you want to update CF components without rebuilding your VM itself, you can SSH into your VM and re-run the Nise BOSH.

```
cd cf-release
vagrant ssh
# in the VM
./install_release.sh
```

#### Notes for Updating Devbox

These scripts do *not* automatically update existing files in the working directory.

You need to delete the `cf_nise_installer` directory created by the `bootstrap.sh` script to apply changes on environment variables below and other modification in outer repositories such as `cf-release`. You are alwo able to manually edit files in the directory and run `install.sh` or each script required to install.


### Environment Variables

You can customize your installation using environment variables.

| Name              | Description                              | Used in                                 | Default                                        |
| :---------------: | :--------------------------------------: | :-------------------------------------: | :--------------------------------------------: |
| INSTALLER_URL     | URI for cf_nise_installer                | bootstrap.sh                            | https://github.com/yudai/cf_nise_installer.git |
| INSTALLER_BRANCH  | Branch/Revision for cf_nise_installer    | bootstrap.sh                            | master                                         |
| CF_RELEASE_URL    | URI for cf-release                       | clone_cf_release.sh                     | https://github.com/cloudfoundry/cf-release.git |
| CF_RELEASE_BRANCH | Branch/Revision for cf-release           | clone_cf_release.sh                     | master                                        |
| CF_RELEASE_USE_HEAD | Create a dev release with the head of the branch | clone_cf_release.sh                     | no (set `yes` to enable)                        |
| NISE_IP_ADDRESS   | IP address for the VM. When this variable is set, the attached network will be bridged  | launch_nise_bosh.sh, register_service_tokens.sh | *nil* (192.168.10.10, not bridged) |
| VAGRANT_MEMORY    | Memory size for the VM                   | launch_nise_bosh.sh                     | 4096                                           |
| NISE_DOMAIN       | Domain name for the devbox               | launch_nise_bosh.sh                     | *nil* (<ip_address>.xip.io)                    |

## Playing with installed Devbox

You can target and login to your installed devbox using following values:


| Target URI     | api.\<IP Address\>.xip.io | api.192.168.10.10.xip.io |
| :------------: | :-----------------------: | :----------------------: |
| Admin User     | micro@vcap.me             | <-                       |
| Admin Password | micr0@micr0               | <-                       |

When you installed your devbox with Vagrant, you can access your devbox only from the host machine that runs the VM.

'[xip.io](http://xip.io/)' is a DNS service provided by 37signals that returns the IP address specified in the subdomain of FQDNs.

## Other resources

* [cf-vagrant-installer](https://github.com/Altoros/cf-vagrant-installer)
   * Another Chef-based vagrant project
