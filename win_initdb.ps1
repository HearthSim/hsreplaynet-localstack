Invoke-Expression "docker-compose run django pipenv run django-admin.py migrate"
Invoke-Expression "docker-compose run django pipenv run python /opt/hsreplay.net/initdb.py"
Invoke-Expression "docker-compose run django pipenv run django-admin.py load_cards"
