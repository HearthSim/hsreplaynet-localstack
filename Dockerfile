FROM python:3.6-stretch
MAINTAINER Jerome Leclanche

# Prepare app directory
RUN mkdir -p /opt/hsreplay.net

COPY sources_extra.list /etc/apt/sources.list.d/sources_extra.list
RUN wget https://deb.nodesource.com/gpgkey/nodesource.gpg.key -qO - | apt-key add - && \
	wget https://dl.yarnpkg.com/debian/pubkey.gpg -qO - | apt-key add -  && \
	apt-get update -qy && apt-get -qy install nodejs yarn

# Virtualenv
RUN python3.6 -m venv /opt/hsreplay.net/env
RUN /opt/hsreplay.net/env/bin/pip install --upgrade pip wheel setuptools pipenv

# Install caddy
COPY caddy /opt/hsreplay.net/caddy/caddy

# Install requirements
COPY requirements.txt /opt/hsreplay.net/requirements/debug.txt
COPY HSReplay.net/requirements/ /opt/hsreplay.net/requirements/
RUN /opt/hsreplay.net/env/bin/pip install -r /opt/hsreplay.net/requirements/web.txt
RUN /opt/hsreplay.net/env/bin/pip install -r /opt/hsreplay.net/requirements/debug.txt

ADD HSReplay.net /opt/hsreplay.net/source
WORKDIR /opt/hsreplay.net/source

# RUN /opt/hsreplay.net/env/bin/python manage.py makemigrations && \
# 	/opt/hsreplay.net/env/bin/python manage.py migrate

EXPOSE 8000

ENV DATABASE_HOST=172.17.0.1 PYTHON=/opt/hsreplay.net/env/bin/python PYTHONPATH=/opt/hsreplay.net/source

# Build frontend
RUN yarn install --pure-lockfile --no-progress
RUN apt-get install unzip
RUN /opt/hsreplay.net/source/scripts/get_vendor_static.sh
RUN yarn run webpack

# Launch WSGI server
COPY uwsgi.ini /opt/hsreplay.net/uwsgi.ini
RUN /opt/hsreplay.net/env/bin/uwsgi --ini /opt/hsreplay.net/uwsgi.ini

# Launch Caddy
COPY Caddyfile /opt/hsreplay.net/caddy/Caddyfile
RUN /opt/hsreplay.net/caddy/caddy --conf /opt/hsreplay.net/caddy/Caddyfile --host 0.0.0.0 --port 80
