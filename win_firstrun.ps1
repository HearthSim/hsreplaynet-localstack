$basedir = "."

if (-not (Test-Path "$basedir/HSReplay.net")) {
	git clone "git@github.com:HearthSim/HSReplay.net" "$basedir/HSReplay.net"
}

if (-not (Test-Path "$basedir/HSReplay.net/locale")) {
	git clone "git@github.com:HearthSim/hsreplaynet-i18n" "$basedir/HSReplay.net/locale"
}

$localSettings = "$basedir/HSReplay.net/hsreplaynet/local_settings.py"
if (-not (Test-Path $localSettings)) {
	"Generating new local_settings.py"
	Copy-Item "$basedir/scripts/local_settings.py" $localSettings
}

if (-not (Test-Path "$basedir/hsreplaynet-dev-proxy")) {
	git clone "git@github.com:HearthSim/hsreplaynet-dev-proxy.git" "$basedir/hsreplaynet-dev-proxy"
}

if (-not (Test-Path "$basedir/.env")) {
    "HSREPLAYNET_SESSIONID=your_sessionid_here" >> "$basedir/.env"
}


"Running build"
Invoke-Expression "docker-compose build"
Invoke-Expression "docker-compose pull"

Invoke-Expression "docker-compose run django /opt/hsreplay.net/source/scripts/get_vendor_static.sh"
Invoke-Expression "docker-compose run django pipenv install --dev --skip-lock"

"------------------------------------------------"
"All done. Run the following command to start:"
"    $ docker-compose up`n"
"Once up, you probably want to run the following:"
"    $ ./win_initdb.ps1`n"
