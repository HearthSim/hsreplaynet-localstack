#!/bin/bash


BASEDIR="$(readlink -f "$(dirname "$0")/..")"
GITHUB="git@github.com:HearthSim"

HSREPLAYNET_GIT="$GITHUB/HSReplay.net"
JOUST_GIT="$GITHUB/Joust"


cd "$BASEDIR" || exit 1

if [[ ! -d $BASEDIR/HSReplay.net ]]; then
	git clone "$HSREPLAYNET_GIT"
fi

if [[ ! -d $BASEDIR/Joust ]]; then
	git clone "$JOUST_GIT"
fi


vagrant up &&
vagrant ssh -c "/bin/bash /home/vagrant/projects/scripts/provision_run.sh"
