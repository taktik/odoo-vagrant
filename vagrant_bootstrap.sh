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
cp -f /vagrant/templates/pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf
