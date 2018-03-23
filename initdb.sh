#!/bin/bash
docker-compose run django pipenv run django-admin.py migrate
docker-compose run django pipenv run python /opt/hsreplay.net/initdb.py
docker-compose run django pipenv run django-admin.py load_cards
