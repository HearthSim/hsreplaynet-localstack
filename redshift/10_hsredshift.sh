cd /tmp/hsredshift/udfs

export DB_CONNECTION=postgresql://postgres@:5432/dev

/usr/bin/python3.7 ./setup.py load_into_postgres
/usr/bin/python3.7 -m hsredshift.etl.models --apply
/usr/bin/python3.7 -m hsredshift.etl.views --apply
