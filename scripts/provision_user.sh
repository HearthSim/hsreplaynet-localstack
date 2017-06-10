#!/usr/bin/env bash

ZSH_PROFILE="$HOME/.config/zsh/profile"

mkdir -p "$HOME/.cache" "$HOME/.config/zsh"
cat > "$ZSH_PROFILE" <<EOF
source \$HOME/env/bin/activate
export NODE_MODULES="\$HOME/node_modules"
export PATH="\$VIRTUAL_ENV/bin:\$NODE_MODULES/.bin:\$PATH"
export PROJECTDIR=\$HOME/projects
export HSREPLAYNET=\$PROJECTDIR/hsreplay.net
export PYTHONPATH=\$HSREPLAYNET
export DJANGO_SETTINGS_MODULE=hsreplaynet.settings
export HSREPLAYNET_DEBUG=1
export ENV_VAGRANT=1
export GITHUB="git@github.com:HearthSim"

cd \$HSREPLAYNET
EOF
cp /etc/skel/.zshrc "$HOME/.zshrc"

python3 -m venv "$HOME/env"
source "$ZSH_PROFILE"

pip install --upgrade pip setuptools
pip install -r "$HSREPLAYNET/requirements/dev.txt"

cd "$HSREPLAYNET" || exit
yarn install --modules-folder "$NODE_MODULES" --pure-lockfile --no-progress

if [[ ! -e $HSREPLAYNET/hsreplaynet/local_settings.py ]]; then
	cp "$HSREPLAYNET/local_settings.example.py" "$HSREPLAYNET/hsreplaynet/local_settings.py"
fi

if [[ -e $PROJECTDIR/joust ]]; then
	git -C "$PROJECTDIR/joust" fetch -q --all && git -C "$PROJECTDIR/joust" reset -q --hard origin/master
else
	git clone -q "$GITHUB/Joust" "$PROJECTDIR/joust"
fi

createdb --username postgres hsreplaynet
python "$HSREPLAYNET/manage.py" migrate --no-input
python "$HSREPLAYNET/manage.py" load_cards
python "$PROJECTDIR/scripts/initdb.py"

influx --execute "create database hdt"
influx --execute "create database hsreplaynet"
influx --execute "create database joust"

if [[ ! -d $HSREPLAYNET/hsreplaynet/static/vendor ]]; then
	"$HSREPLAYNET/scripts/get_vendor_static.sh"
fi

mkdir -p "$HSREPLAYNET/build/generated"
