#!/bin/bash

basedir="."

if [[ ! -e "$basedir/HSReplay.net" ]]; then
	git clone "git@github.com:HearthSim/HSReplay.net" "$basedir/HSReplay.net"
fi

if [[ ! -e "$basedir/HSReplay.net/locale" ]]; then
	git clone "git@github.com:HearthSim/hsreplaynet-i18n" "$basedir/HSReplay.net/locale"
fi

if [[ ! -e "$basedir/HSReplay.net/hsreplaynet/local_settings.py" ]]; then
	echo "Generating new local_settings.py"
	cp "$basedir/scripts/local_settings.py" "$basedir/HSReplay.net/hsreplaynet/local_settings.py"
fi

mkdir -p "$basedir/HSReplay.net/build/generated/"

echo "Running build"
docker-compose build --pull
docker-compose pull

docker-compose run django /opt/hsreplay.net/source/scripts/get_vendor_static.sh
docker-compose run django pipenv install --dev --skip-lock

echo
echo "------------------------------------------------"
echo "All done. Run the following command to start:"
echo "    $ docker-compose up"
echo
echo "Once up, you probably want to run the following:"
echo "    $ ./initdb.sh"
echo
