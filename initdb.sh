#!/bin/bash
docker-compose run django pipenv run django-admin.py migrate
docker-compose run django pipenv run python /opt/hsreplay.net/initdb.py
