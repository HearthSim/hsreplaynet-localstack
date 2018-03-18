FROM python:3.6-stretch

RUN apt-get update && apt-get -qy install gettext unzip

# Install requirements
COPY HSReplay.net/requirements /opt/hsreplay.net/requirements
COPY scripts/initdb.py /opt/hsreplay.net/initdb.py
RUN pip install --upgrade pip wheel setuptools pipenv && \
	pip install -r /opt/hsreplay.net/requirements/web.txt && \
	pip install q moto

ENV PYTHONPATH=/opt/hsreplay.net/source NODE_ENV=development
