FROM hearthsim/pgredshift:latest

RUN apt-get update && apt-get install -y --no-install-recommends git && \
	git clone https://github.com/HearthSim/hsredshift/ /tmp/hsredshift

WORKDIR /tmp/hsredshift
RUN /usr/bin/python3.7 -m pip install .

WORKDIR /tmp/hsredshift/udfs
RUN /usr/bin/python3.7 -m pip install hearthstone sqlalchemy

RUN \
	/usr/bin/python3.7 ./setup.py bdist_wheel && \
	/usr/bin/python3.7 -m pip install ./dist/*.whl && \
	/usr/bin/python2.7 -m pip install ./dist/*.whl

COPY 10_hsredshift.sh "/docker-entrypoint-initdb.d/"
