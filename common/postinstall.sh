#!/bin/bash -ex

# Be careful, this file may be a symbolic link

sudo sed -i "s/check process vcap_registrar/check process vcap_registrar_login/" /var/vcap/monit/job/0001_micro.login.monitrc
sudo sed -i "s/vcap_registrar.pid/vcap_registrar_login.pid/" /var/vcap/monit/job/0001_micro.login.monitrc
sudo sed -i "s/vcap_registrar.pid/vcap_registrar_login.pid/" /var/vcap/jobs/login/bin/vcap_registrar_ctl
