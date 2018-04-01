$basedir = "."

if (-not (Test-Path "$basedir/HSReplay.net")) {
	git clone "https://github.com/hearthsim/HSReplay.net" "$basedir/HSReplay.net"
}

$localSettings = "$basedir/HSReplay.net/hsreplaynet/local_settings.py"
if (-not (Test-Path $localSettings)) {
	"Generating new local_settings.py"
	Copy-Item "$basedir/scripts/local_settings.py" $localSettings
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
