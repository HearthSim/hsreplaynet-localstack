#!/bin/bash

sudo /usr/local/bin/pip2.7 install --upgrade hearthstone

cd ~/projects/hsredshift/udfs
DB_CONNECTION=postgresql://postgres@localhost/test_hsredshift /usr/bin/python2.7 ./setup.py load_into_postgres
sudo /usr/bin/python2.7 ./setup.py install
