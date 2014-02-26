# Cloud Foundry v2 Nise Installer

## Devbox Installer with Nise BOSH

CF Nise Installer is a set of scripts that installs a Cloud Foundry v2 instance to your single machine or Vagrant VM. You can build your own 'devbox' quickly with a single command with this installer.

CF Nise Installer is based on [cf-release](https://github.com/cloudfoundry/cf-release) by Pivotal, [Nise BOSH](http://github.com/nttlabs/nise_bosh/) by NTT Laboratory.

### *NOTICE*

This installer is mainly for testing installation with BOSH. If you just want to try Cloud Foundry, [bosh-lite](https://github.com/cloudfoundry/bosh-lite) and [cf-vagrant-installer](https://github.com/Altoros/cf-vagrant-installer) may be a better solution for you.

When ask a question about Cloud Foundry build by this installer at vcap-dev, please describe that you are uing cf-nise-installer in your post. That makes isolating the problem and answering your question easier. If the problem you get is certainly caused by this installer, please do not post to vcap-dev and submit a issue to this repository.

### Services

You can add services to a CF instance created by this installer using [cf_nise_installer_services](https://github.com/yudai/cf_nise_installer_services). Currently only postgresql is available.


## Building Devbox on Single Server

This section shows you how to install CF components to your server.

If you want to build a devbox on a Vagrant VM, skip this section and see the next section.

### Requirements

* Ubuntu 10.04 or 12.04 64bit
   * *Ubuntu 10.04 is recommended*
   * Do NOT install RVM to avoid conflicting with RBenv
* 8GB+ free HDD space
* 2GB+ memory
   * m1.medium or larger instance is recommended on AWS

### Installing Cloud Foundry Components

Run the commands below on your server:

```sh
sudo apt-get install curl
bash < <(curl -s -k -B https://raw.github.com/yudai/cf_nise_installer/${INSTALLER_BRANCH:-master}/scripts/bootstrap.sh)
```

The `bootstrap.sh` script installs everything needed for your devbox. This command may take a couple of hours at first run.

You need to restart your server once after the installation is completed.

### Launching Processes

You can start the processes for your devbox by running the following command in the `cf_nise_installer` directory cloned by the `bootstrap.sh` script:

```sh
./scripts/start.sh
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

To update your existing Devbox, you can use scripts in the `scripts` directory. You don't need to execute the `bootstrap.sh` script for this purpose.

* install.sh
  * Runs the following scripts in order
* install_ruby.sh
  * Installs Ruby binaries with Rbenv
* clone_nise_bosh.sh
  * Clones the `nise_bosh` repository
  * When the `nise_bosh` directory is not empty, does nothing.
* clone_cf_release.sh
  * Clones the `cf-release` repository
  * When the `cf-release` directory is not empty, does nothing.
* install_environemnt.sh
  * Run the `init` command of Nise BOSH
* install_cf_release.sh
  * Installs cf-release jobs and packages with Nise BOSH

* start.sh
  * Invokes the Monit process and CF processes
* stop.sh
  * Stop all CF processes

When run these scrips, be sure your are in the `cf_nise_installer` directory, and not in `scripts` directory.

#### Notes for Updating Devbox

These scripts do *not* automatically update existing files in the working directory such as the `cf-release` and `nise_bosh` directories.

You need to delete the `cf_nise_installer` directory created by the `bootstrap.sh` script to apply changes on environment variables below and other modification in outer repositories such as `cf-release`. You are alwo able to manually edit files in the directory and run `install.sh` or each script required to install.


### Environment Variables

You can customize your installation using environment variables.

| Name              | Description                              | Used in                                 | Default                                        |
| :---------------: | :--------------------------------------: | :-------------------------------------: | :--------------------------------------------: |
| INSTALLER_URL     | URI for cf_nise_installer                | bootstrap.sh                            | https://github.com/yudai/cf_nise_installer.git |
| INSTALLER_BRANCH  | Branch/Revision for cf_nise_installer    | bootstrap.sh                            | master                                         |
| CF_RELEASE_URL    | URI for cf-release | clone_cf_release.sh | clone_cf_release.sh                     | *nil* (https://github.com/cloudfoundry/cf-release.git is set to submodule)|
| CF_RELEASE_BRANCH | Branch/Revision for cf-release           | clone_cf_release.sh                     | *nil* (certain stable revision is set to submodule) |
| CF_RELEASE_USE_HEAD | Create a dev release with the head of the branch | clone_cf_release.sh           | no (set `yes` to enable)                       |
| NISE_BOSH_REV     | Git revision specifier [note] of nise_bosh repo | clone_nise_bosh.sh               | *nil* (currently checked-out revision)         |
| NISE_IP_ADDRESS   | IP address to bind CF components         | install_cf_release.sh                   | Automatically detected using `ip` command      |
| NISE_DOMAIN       | Domain name for the devbox               | install_cf_release.sh                   | *nil* (<ip_address>.xip.io)                    |
| NISE_PASSWORD     | Password for CF components               | install_cf_release.sh                   | c1oudc0w                                       |

[note]: Do *not* use any relative revision specifier from HEAD (e.g. `HEAD~`, `HEAD~10`, `HEAD^^`). Please use an absolute revision specifier (e.g. `123abc`, `develop`). You may use a relative revision specifier from an absolute revision specifier (e.g. `master~~`).

## Build Devbox with Vagrant

You can create a devbox VM quickly with a VM using Vagrant.

#### Requirements

* Vagrant 1.4 or later
* Ruby 1.9.3-p484
* 8GB+ free HDD space
* 2GB+ free memory

### Launch Vagrant VM

Clone this repository and run the command below.

```sh
vagrant up
```

Your working directory will be mount at `/vagrant`.