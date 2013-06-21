#!/bin/bash -ex

# Be careful, this file may be a symbolic link

port=2545
sudo apt-get install -y postgresql postgresql-contrib
sudo sed -i "s/^port = 5432/port = ${port}/" /etc/postgresql/8.4/main/postgresql.conf
sudo sed -i "s/^#listen_addresses/listen_addresses/" /etc/postgresql/8.4/main/postgresql.conf

cat <<EOF | sudo tee /etc/postgresql/8.4/main/pg_hba.conf
local   all             all                                     trust
host    all             all             127.0.0.1/32            trust
host    all             all             ::1/128                 trust
host    all             all             0.0.0.0/0               md5
EOF

for role in root admin; do
    echo "host    all  ${role} 0.0.0.0/0 md5" | sudo tee -a /etc/postgresql/8.4/main/pg_hba.conf
done

sudo /etc/init.d/postgresql-8.4 restart

sleep 60

for role in root uaa; do
    psql -U postgres -p ${port} -d postgres -c "CREATE ROLE \"${role}\""
    psql -U postgres -p ${port} -d postgres -c "ALTER ROLE \"${role}\" WITH LOGIN PASSWORD ''"
done

for db in appcloud_ng uaa; do
    sudo -u postgres createdb "${db}" -p ${port}
    psql -U postgres -p ${port} -d "${db}" -f /usr/share/postgresql/8.4/contrib/citext.sql
done


sudo sed -i "s/check process vcap_registrar/check process vcap_registrar_login/" /var/vcap/monit/job/0001_micro.login.monitrc
sudo sed -i "s/vcap_registrar.pid/vcap_registrar_login.pid/" /var/vcap/monit/job/0001_micro.login.monitrc
sudo sed -i "s/vcap_registrar.pid/vcap_registrar_login.pid/" /var/vcap/jobs/login/bin/vcap_registrar_ctl
