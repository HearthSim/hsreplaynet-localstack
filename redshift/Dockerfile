FROM hearthsim/pgredshift:latest

RUN apt-get install -y --no-install-recommends git && \
	git clone https://github.com/HearthSim/hsredshift/ /tmp/hsredshift

WORKDIR /tmp/hsredshift
RUN /usr/bin/python3.5 -m pip install .

WORKDIR /tmp/hsredshift/udfs
RUN /usr/bin/python2.7 -m pip install hearthstone sqlalchemy && \
	/usr/bin/python2.7 ./setup.py install

COPY 10_hsredshift.sh "/docker-entrypoint-initdb.d/"
