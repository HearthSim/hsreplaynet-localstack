FROM python:3.6-stretch

RUN apt-get update && apt-get -qy install gettext unzip

# Install requirements
COPY HSReplay.net/requirements /opt/hsreplay.net/requirements
COPY requirements.txt /opt/hsreplay.net/requirements/docker.txt
COPY scripts/initdb.py /opt/hsreplay.net/initdb.py

RUN pip install --upgrade pip wheel setuptools pipenv && \
	pip install -r /opt/hsreplay.net/requirements/web.txt && \
	pip install -r /opt/hsreplay.net/requirements/docker.txt

ENV PYTHONPATH=/opt/hsreplay.net/source
CMD ["/opt/hsreplay.net/source/manage.py", "runserver", "0.0.0.0:8000"]
