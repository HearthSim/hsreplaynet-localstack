#!/bin/bash

PROJECTDIR="$HOME/projects"
HSREPLAYNET="$PROJECTDIR/HSReplay.net"
NODE_MODULES="$HOME/node_modules"

source "$HOME/env/bin/activate"
export AWS_DEFAULT_REGION=us-east-1

# Kill remnants
killall -9 -q python node

echo "Starting Django server"
python "$HSREPLAYNET/manage.py" runserver 0.0.0.0:8000 &

echo "Starting Webpack watcher"
"$NODE_MODULES/webpack/bin/webpack.js" -d \
	--devtool cheap-module-eval-source-map \
	--env.cache \
	--config "$HSREPLAYNET/webpack.config.js" \
	--progress \
	--watch
