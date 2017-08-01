#!/bin/bash
export DB_CONNECTION=postgresql://postgres@localhost/test_hsredshift

sudo /usr/local/bin/pip2.7 install --upgrade hearthstone

cd ~/projects/hsredshift/udfs
/usr/bin/python2.7 ./setup.py load_into_postgres
sudo /usr/bin/python2.7 ./setup.py install

python -m hsredshift.utils.postgres_compat --apply
python -m hsredshift.etl.models --apply
python -m hsredshift.etl.views --apply
