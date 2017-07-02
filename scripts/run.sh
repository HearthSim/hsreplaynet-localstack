#!/bin/bash

set -e


BASEDIR="$(dirname "$0")/..)"
GITHUB="git@github.com:HearthSim"

HSREPLAYNET_GIT="$GITHUB/HSReplay.net"
JOUST_GIT="$GITHUB/Joust"
HEARTHSIM_IDENTITY_GIT="$GITHUB/hearthsim-identity"
PYTHON_HEARTHSTONE_GIT="$GITHUB/python-hearthstone"
PYTHON_HSLOG_GIT="$GITHUB/python-hslog"
HSREPLAY_GIT="$GITHUB/hsreplay"
HSREDSHIFT_GIT="$GITHUB/hsredshift"


cd "$BASEDIR" || exit 1

if [[ ! -d $BASEDIR/HSReplay.net ]]; then
	git clone "$HSREPLAYNET_GIT"
fi

if [[ ! -d $BASEDIR/hearthsim-identity ]]; then
	git clone "$HEARTHSIM_IDENTITY_GIT"
fi

if [[ ! -d $BASEDIR/python-hearthstone ]]; then
	git clone "$PYTHON_HEARTHSTONE_GIT"
fi

if [[ ! -d $BASEDIR/python-hslog ]]; then
	git clone "$PYTHON_HSLOG_GIT"
fi

if [[ ! -d $BASEDIR/hsredshift ]]; then
	git clone "$HSREDSHIFT_GIT"
fi

if [[ ! -d $BASEDIR/hsreplay ]]; then
	git clone "$HSREPLAY_GIT"
fi

if [[ ! -d $BASEDIR/Joust ]]; then
	git clone "$JOUST_GIT"
fi


vagrant up &&
vagrant ssh -c "/bin/bash /home/vagrant/projects/scripts/provision_run.sh"
