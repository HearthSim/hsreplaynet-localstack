docker-compose run django /opt/hsreplay.net/source/scripts/get_vendor_static.sh
docker-compose run django /opt/hsreplay.net/source/manage.py migrate
