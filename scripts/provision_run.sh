PROJECTDIR="$HOME/projects"
PROJECT="$PROJECTDIR/hsreplay.net"
source "$HOME/env/bin/activate"
export ENV_VAGRANT=1
export HSREPLAYNET_DEBUG=1
export PATH="$HOME/node_modules/.bin:$PATH"

# Kill remnants
killall -9 -q python node sassc

echo "Starting Django server"
python "$PROJECT/manage.py" runserver 0.0.0.0:8000 &

echo "Starting webpack watcher"
PYTHONPATH="$PROJECT" webpack -d \
	--devtool cheap-module-eval-source-map \
	--env.cache \
	--config "$PROJECT/webpack.config.js" \
	--watch &

echo "Starting scss watcher"
sassc "$PROJECT/hsreplaynet/static/styles/main.scss" "$PROJECT/hsreplaynet/static/styles/main.css" \
	--sourcemap --source-comments \
	--watch &

echo "Starting RQ Workers"
python "$PROJECT/manage.py" rqworker &

echo "Starting Django SSL server"
python "$PROJECT/manage.py" runsslserver 0.0.0.0:8443
