#!/bin/bash
export DB_CONNECTION=postgresql://postgres@localhost/test_hsredshift
export PYTHON=/usr/bin/python2.7

sudo "$PYTHON" -m pip install --upgrade hearthstone

cd ~/projects/hsredshift/udfs
"$PYTHON" ./setup.py load_into_postgres
sudo "$PYTHON" ./setup.py install

python -m hsredshift.utils.postgres_compat --apply
python -m hsredshift.etl.models --apply
python -m hsredshift.etl.views --apply
