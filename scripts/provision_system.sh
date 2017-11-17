#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

# Install apt https support first
dpkg -s apt-transport-https &>/dev/null || {
	apt-get update -q
	apt-get install -qy apt-transport-https
}

# echo "deb http://deb.debian.org/debian unstable main contrib" > /etc/apt/sources.list.d/unstable.list
echo "deb https://repos.influxdata.com/debian stretch stable" > /etc/apt/sources.list.d/influxdb.list
echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" > /etc/apt/sources.list.d/postgres.list
echo "deb https://deb.nodesource.com/node_8.x stretch main" > /etc/apt/sources.list.d/nodejs.list
echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
wget https://repos.influxdata.com/influxdb.key -qO - | apt-key add -
wget https://www.postgresql.org/media/keys/ACCC4CF8.asc -qO - | apt-key add -
wget https://deb.nodesource.com/gpgkey/nodesource.gpg.key -qO - | apt-key add -
wget https://dl.yarnpkg.com/debian/pubkey.gpg -qO - | apt-key add -

apt update -q
apt full-upgrade -qy

# General dependencies
apt install -qy curl dos2unix git vim ack htop iotop mlocate psmisc strace tcpdump tree unzip zsh

# Libraries and compiler
apt install -qy gcc g++ \
	libxml2 libxml2-dev libxslt1-dev libssl-dev libffi-dev libpq-dev \
	libbz2-dev libsqlite3-dev libreadline-dev zlib1g-dev

# Third party libraries
apt install -qy nodejs yarn supervisor influxdb redis-server

# Postgres
apt install -qy postgresql-9.6 postgresql-plpython-9.6 postgresql-plpython3-9.6 postgresql-server-dev-9.6

# Redis
apt install redis-server

# Python 3.5 (core)
apt install -qy python3 python3-dev python3-venv

# Python 2.7 pip (make sure it's up to date)
apt install -qy --no-install-recommends python-pip python-enum34 python-psycopg2 python-sqlalchemy
python2 -m pip install --upgrade pip wheel setuptools

# Cleanup
apt autoremove --purge -y

# Compile query_group redshift compat extension
set -e
rm -rf "$HOME/pgredshift"
cp -rf "/home/vagrant/projects/scripts/pgredshift" "$HOME/pgredshift"
make -C "$HOME/pgredshift" && make -C "$HOME/pgredshift" install
rm -rf "$HOME/pgredshift"


# postgresql configuration

echo "
local all postgres trust
local all all peer
host all all 127.0.0.1/32 trust
host all all ::1/128 trust
host all all 10.0.0.0/16 trust" > /etc/postgresql/9.6/main/pg_hba.conf

# replace listen_addresses with *
sed "/listen_addresses/d" -i /etc/postgresql/9.6/main/postgresql.conf
echo "listen_addresses = '*'" >> /etc/postgresql/9.6/main/postgresql.conf

# load query_group extension
sed "/shared_preload_libraries/d" -i /etc/postgresql/9.6/main/postgresql.conf
echo "shared_preload_libraries = 'query_group'" >> /etc/postgresql/9.6/main/postgresql.conf


systemctl enable postgresql.service
systemctl restart postgresql.service

systemctl enable influxdb
systemctl start influxdb

if [[ ! -e /etc/skel/.zshrc ]]; then
	wget -q https://raw.githubusercontent.com/jleclanche/dotfiles/master/.zshrc -O /etc/skel/.zshrc
fi

chsh -s /bin/zsh
chsh -s /bin/zsh vagrant
cp /etc/skel/.zshrc "$HOME/.zshrc"
mkdir -p "$HOME/.cache"
