#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

# Install apt https support first
dpkg -s apt-transport-https &>/dev/null || {
	apt-get update -q
	apt-get install -qy apt-transport-https
}

echo "deb http://cloudfront.debian.net/debian jessie-backports main
deb-src http://cloudfront.debian.net/debian jessie-backports main" > /etc/apt/sources.list.d/backports.list
echo "deb http://deb.debian.org/debian unstable main contrib" > /etc/apt/sources.list.d/unstable.list
echo "deb https://repos.influxdata.com/debian jessie stable" > /etc/apt/sources.list.d/influxdb.list
echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" > /etc/apt/sources.list.d/postgres.list
echo "deb https://deb.nodesource.com/node_7.x jessie main" > /etc/apt/sources.list.d/nodejs.list
echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
wget https://repos.influxdata.com/influxdb.key -qO - | apt-key add -
wget https://www.postgresql.org/media/keys/ACCC4CF8.asc -qO - | apt-key add -
wget https://deb.nodesource.com/gpgkey/nodesource.gpg.key -qO - | apt-key add -
wget https://dl.yarnpkg.com/debian/pubkey.gpg -qO - | apt-key add -

# Pin unstable at 300
echo "Package: *
Pin: release o=Debian,a=unstable
Pin-Priority: 300" > /etc/apt/preferences

apt update -q
apt full-upgrade -qy

# General dependencies
apt install -qy curl git vim htop iotop mlocate strace tcpdump tree unzip zsh

# Libraries and compiler
apt install -qy gcc g++ libxml2 libxml2-dev libxslt1-dev libssl-dev libffi-dev libpq-dev

# Python 3.6 (dpkg upgrade needed to compile c libraries)
apt install -qyt unstable python3.6 python3.6-dev python3.6-venv libdpkg-perl
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 1

# Third party libraries
apt install -qy nodejs yarn supervisor influxdb postgresql-9.6 redis-server

# Backports
apt-get install -qyt jessie-backports redis-server

# Enable trust authentication for postgresql
sed -i "s/all *postgres *peer/all postgres trust/" /etc/postgresql/9.6/main/pg_hba.conf
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
