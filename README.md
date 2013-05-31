# Cloud Foundry v2 installer with Nise BOSH (+ Vagrant)

## Links

* [cf-vagrant-installer](https://github.com/Altoros/cf-vagrant-installer)
 * Another Chef-based vagrant project

## Install Cloud Foundry v2

### On local machine

#### Requirements

* Ubuntu 10.04 64bit

#### Full-automatic install

```sh
sudo apt-get install curl
bash < <(curl -s -k -B https://raw.github.com/yudai/cf_nise_installer/master/scripts/bootstrap.sh)
```

#### Customized install

TODO

#### Process management

Use Monit which installed by Nise BOSH.

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

### With Vagrant

You can create a devbox vagrant VM with [nise-bosh-vagrant](https://github.com/BrianMMcClain/nise-bosh-vagrant).

#### Requirements

* Vagrant 1.2 or later
* Ruby 1.9.3-p392 (Required by cf-release)

#### Install

```sh
# Install required gems, add `sudo` if needed
gem install bosh_cli bundler nise-bosh-vagrant
rbenv rehash # for rbenv users

# Clone this repository
git clone https://github.com/yudai/cf_nise_installer.git

# Clone the latest cf-release and create a release
# You can also use your customized cf-release if needed
./cf_nise_installer/scripts/clone_cf_release.sh

# Run
nise-bosh-vagrant ./cf-release --manifest ./cf_nise_installer/manifests/micro.yml --postinstall ./cf_nise_installer/scripts/postinstall.sh --memory 4096 --start
```

## Play with Cloud Foundry v2

| Target URI     | api.\<IP Address\>.xip.io | api.192.168.10.10.xip.io |
| :------------: | :-----------------------: | :----------------------: |
| Admin User     | micro@vcap.me             | <-                       |
| Admin Password | micr0@micr0               | <-                       |

### Service token registration

To create services, register tokens to UAA.

```sh
# login as an admin in advance
gem install admin-cf-plugin
cf create-service-auth-token --provider core --token token --label postgresql
cf create-service-auth-token --provider core --token token --label mysql
```
