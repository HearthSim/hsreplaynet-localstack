#!/usr/bin/env bash

# Install apt https support first
dpkg -s apt-transport-https &>/dev/null || {
	apt-get update -q
	apt-get install -qy apt-transport-https
}

echo 'deb http://cloudfront.debian.net/debian jessie-backports main
deb-src http://cloudfront.debian.net/debian jessie-backports main' > /etc/apt/sources.list.d/backports.list
echo "deb https://repos.influxdata.com/debian jessie stable" > /etc/apt/sources.list.d/influxdb.list
echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" > /etc/apt/sources.list.d/postgres.list
echo "deb https://deb.nodesource.com/node_7.x jessie main" > /etc/apt/sources.list.d/nodejs.list
echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
wget https://repos.influxdata.com/influxdb.key -qO - | apt-key add -
wget https://www.postgresql.org/media/keys/ACCC4CF8.asc -qO - | apt-key add -
wget https://deb.nodesource.com/gpgkey/nodesource.gpg.key -qO - | apt-key add -
wget https://dl.yarnpkg.com/debian/pubkey.gpg -qO - | apt-key add -


apt-get update -q
apt-get dist-upgrade -qy
apt-get install -qy \
	zsh curl git htop tree unzip vim \
	python3 python3-dev python3-venv \
	gcc g++ libxml2 libxml2-dev libxslt1-dev libssl-dev \
	nodejs yarn \
	supervisor influxdb \
	python-dev libffi-dev
apt-get install -qy -t jessie-backports postgresql-9.6 libpq-dev
apt-get install -qy -t jessie-backports redis-server

# Enable trust authentication for postgresql
sed -i 's/all *postgres *peer/all postgres trust/' /etc/postgresql/9.6/main/pg_hba.conf
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
