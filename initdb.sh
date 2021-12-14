#!/bin/bash
docker-compose exec django pipenv run django-admin.py migrate
docker-compose exec django pipenv run python /opt/hsreplay.net/initdb.py
docker-compose exec django pipenv run django-admin.py load_cards
docker-compose exec django pipenv run django-admin.py load_mercenaries
