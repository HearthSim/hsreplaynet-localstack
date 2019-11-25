FROM hearthsim/pgredshift:latest

RUN apt-get update && apt-get install -y --no-install-recommends curl

RUN curl -O https://libs.hearthsim.net/hsredshift-0.1.0.tar.gz && \
	mkdir /tmp/hsredshift && tar -xzf hsredshift-0.1.0.tar.gz -C /tmp/hsredshift --strip 1

RUN apt-get install -y --no-install-recommends build-essential python3-dev libpq-dev

WORKDIR /tmp/hsredshift
RUN /usr/bin/python3.7 -m pip install .

RUN curl -O https://libs.hearthsim.net/hsredshift_udfs-0.1.0.tar.gz && \
	mkdir /tmp/hsredshift/udfs && tar -xzf hsredshift_udfs-0.1.0.tar.gz -C /tmp/hsredshift/udfs --strip 1

WORKDIR /tmp/hsredshift/udfs
RUN /usr/bin/python3.7 -m pip install hearthstone sqlalchemy

RUN \
	/usr/bin/python3.7 ./setup.py bdist_wheel && \
	/usr/bin/python3.7 -m pip install ./dist/*.whl && \
	/usr/bin/python2.7 -m pip install ./dist/*.whl

COPY 10_hsredshift.sh "/docker-entrypoint-initdb.d/"
