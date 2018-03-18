# HSReplay.net Local Stack

This repository allows you to run [HSReplay.net](https://github.com/HearthSim/HSReplay.net)
on your local machine.


## Dependencies

 - [Docker](https://docs.docker.com/)
 - [Docker Compose](https://docs.docker.com/compose/)


## Setup

Run `./firstrun.sh` once you have docker-compose installed the first time you set up the image.
That script will do the following:

1. Clone [HSReplay.net](https://github.com/HearthSim/HSReplay.net) in the repository if it's not
   already there. You should use that path as your workspace if you want to modify the site.
2. Prepare and build the docker images for all the services.
3. Set up the local database, migrate it, and feed in some initial data.


## Services list

The following services are available on their default ports:

 - Postgres @ db:5432
 - Redis @ redis:6379
 - Stripe (using [Stripe Mock](https://github.com/stripe/stripe-mock)) @ stripe:1211
 - [AWS Localstack](https://github.com/localstack/localstack) on ports 4567-4583

The site runs on the following ports:
 - django (localhost:8000)
 - frontend (localhost:3000 for webpack-dev-server)


## License & Community

This is a [HearthSim](https://hearthsim.info) project. Join the development
on [Discord](https://discord.gg/hearthsim-devs), or `#HearthSim` on Freeenode.

Licensed under the [MIT license](https://en.wikipedia.org/wiki/MIT_License).
The full license text is available in the `LICENSE` file.
