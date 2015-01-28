#!/bin/sh

set -x
set -e

sudo echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
# Add PostgreSQL's repository. It contains the most recent stable release
#     of PostgreSQL, ``9.3``.
sudo echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list
sudo wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get -y -q install postgresql-client-9.3 postgresql-contrib-9.3

# Replace pg_hba.conf by our own
sudo cp -f /vagrant/templates/pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf

# Allow connections from the outside
sudo sed -e "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" -i /etc/postgresql/9.3/main/postgresql.conf

# Restart PostgreSQL
sudo service postgresql restart

# Fix locale
sudo apt-get update
sudo apt-get install -qq language-pack-en

sudo locale-gen en_US.UTF-8 && \
sudo update-locale LANG=en_US.UTF-8 && \
sudo dpkg-reconfigure locales

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

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
