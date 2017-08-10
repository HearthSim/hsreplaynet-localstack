#!/bin/bash

PROJECTDIR="$HOME/projects"
HSREPLAYNET="$PROJECTDIR/HSReplay.net"

source "$HOME/env/bin/activate"
export ENV_VAGRANT=1
export HSREPLAYNET_DEBUG=1
export PATH="$HOME/node_modules/.bin:$PATH"

# Kill remnants
killall -9 -q python node

echo "Starting Django server"
python "$HSREPLAYNET/manage.py" runserver 0.0.0.0:8000 &

echo "Starting Webpack watcher"
PYTHONPATH="$HSREPLAYNET" webpack -d \
	--devtool cheap-module-eval-source-map \
	--env.cache \
	--config "$HSREPLAYNET/webpack.config.js" \
	--watch &

echo "Starting RQ Workers"
python "$HSREPLAYNET/manage.py" rqworker &

echo "Starting Django SSL server"
python "$HSREPLAYNET/manage.py" runsslserver 0.0.0.0:8443
