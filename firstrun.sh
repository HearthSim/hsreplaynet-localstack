#!/bin/bash

basedir="."

if [[ ! -e "$basedir/HSReplay.net" ]]; then
	git clone "git@github.com:HearthSim/HSReplay.net" "HSReplay.net"
fi

if [[ ! -e "$basedir/HSReplay.net/hsreplaynet/local_settings.py" ]]; then
	echo "Generating new local_settings.py"
	cp "$basedir/scripts/local_settings.py" "$basedir/HSReplay.net/hsreplaynet/local_settings.py"
fi

echo "Running build"
docker-compose build

docker-compose run django /opt/hsreplay.net/source/scripts/get_vendor_static.sh
docker-compose run django /opt/hsreplay.net/source/manage.py migrate

echo
echo "All done. Run the following command to start:"
echo "    $ docker-compose up"
