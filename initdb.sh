#!/bin/bash
docker-compose exec django pipenv run django-admin migrate
docker-compose exec django pipenv run python /opt/hsreplay.net/initdb.py
docker-compose exec django pipenv run django-admin load_cards
docker-compose exec django pipenv run django-admin load_mercenaries
