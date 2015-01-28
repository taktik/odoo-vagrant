#!/bin/sh

set -x
set -e

# Fix locale
sudo apt-get update
sudo apt-get install -qq language-pack-en

sudo locale-gen en_US.UTF-8 && \
sudo update-locale LANG=en_US.UTF-8 && \
sudo dpkg-reconfigure locales

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

sudo echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
# Add PostgreSQL's repository. It contains the most recent stable release
#     of PostgreSQL, ``9.3``.
sudo echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list
sudo wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get -y -q install postgresql-client-9.3 postgresql-contrib-9.3 postgresql-server-dev-9.3

# Replace pg_hba.conf by our own
sudo cp -f /vagrant/templates/pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf

# Allow connections from the outside
sudo sed -e "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" -i /etc/postgresql/9.3/main/postgresql.conf

sudo service postgresql stop

sudo rm -R /var/lib/postgresql/9.3/main
sudo mkdir -p /var/lib/postgresql/9.3/main
sudo chown -R postgres: /var/lib/postgresql/9.3/main
su postgres -c "/usr/lib/postgresql/9.3/bin/initdb -E utf8 --locale=en_US.UTF-8 /var/lib/postgresql/9.3/main"

# Restart PostgreSQL
sudo service postgresql restart

psql -U postgres -c "CREATE USER openerp WITH CREATEDB NOCREATEUSER PASSWORD 'mypassword';"

# Base dependencies and tools
sudo apt-get install -qq aptitude software-properties-common python-software-properties
sudo apt-get install -qq sudo iputils-ping wget vim bzr bzip2 curl htop g++ rsync zip unzip nano curl less
sudo apt-get install -qq python2.7 python2.7-dev python-setuptools
sudo apt-get install -qq rsyslog make net-tools psmisc

# Git (needs software-properties-common python-software-properties)
sudo add-apt-repository ppa:git-core/ppa
sudo apt-get -qq update
sudo apt-get install -qq git

# Odoo dependencies
sudo apt-get install -qq libxml2-dev libxslt1-dev libsasl2-dev libldap2-dev
sudo apt-get install -qq libjpeg-dev libfreetype6 libfreetype6-dev zlib1g-dev file libxrender1 libfontconfig1 libxtst6
sudo apt-get install -qq libncurses5-dev libncurses5

# SSH Config
sudo mkdir -p /home/vagrant/.ssh
sudo cp -f /vagrant/templates/ssh_config /home/vagrant/.ssh/config

if [ -f /vagrant/templates/id_rsa ]; then
    sudo cp -f /vagrant/templates/id_rsa* /home/vagrant/.ssh/
    sudo chmod -R 600 /home/vagrant/.ssh/id_rsa
fi
if [ -f /vagrant/templates/id_rsa.pub ]; then
    sudo cp -f /vagrant/templates/id_rsa.pub /home/vagrant/.ssh/
    sudo chmod -R 644 /home/vagrant/.ssh/id_rsa.pub
fi

sudo chown -R vagrant: /home/vagrant/.ssh