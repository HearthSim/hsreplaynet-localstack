# HearthSim Vagrant Box

[Vagrant](https://vagrantup.com) is a container runner. It allows creation and
provisioning of reproducible virtual machines for multiple virtual "providers".

This is the HearthSim Vagrant Box.
The [Vagrantfile](https://github.com/HearthSim/hearthsim-vagrant/blob/master/Vagrantfile)
is used to configure it.

## TLDR sheet

* Install Vagrant, VirtualBox and Git.
* Use `./scripts/run.sh` to set up and run the virtual machine.
* SSH into it with `vagrant ssh`.
* Use `vagrant destroy` to destroy the virtual machine.

## Defaults

The HearthSim box builds off the Debian Jessie x64 official Vagrant box, with
the [VirtualBox Provider](https://www.vagrantup.com/docs/virtualbox/).

The following ports are exposed:

* 8000 (HTTP)
* 8443 (HTTPS)
* 5432 (Postgres)

All ports must be available on localhost prior to running the box.

Provisioning first runs `scripts/provision_system.sh` as root to set up the
system, then `scripts/provision_user.sh` as the unpriviledged user.

## Installation

### Prerequisites

* [Vagrant](https://vagrantup.com) must be installed.
* [VirtualBox](https://www.virtualbox.org) must be installed, including kernel
  modules.

### Provisioning

The box is a runner for multiple HearthSim projects. It expects, at the very
least, an `HSReplay.net` and `hsredshift` project directory inside of it, cloned
from GitHub.

The `scripts/run.sh` bash script is a helper which clones several HearthSim
projects in the expected directory before attempting to run the box. You can use
it at any time to run the system.

## Management

Inside the box, the `~/projects` directory is shared with the host; it is the
same directory as the hearthsim-vagrant repository root, which also should
contain various HearthSim repositories.

To SSH into it, use `vagrant ssh`. You can at any time reprovision it with
`vagrant up --provision`.

If you want to destroy it (which you may want to do to reprovision cleanly),
use `vagrant destroy`.

## License & Community

This is a [HearthSim](https://hearthsim.info) project. Join the development
on [Discord](https://discord.gg/hearthsim-devs), or `#HearthSim` on Freeenode.

Licensed under the [MIT license](https://en.wikipedia.org/wiki/MIT_License).
The full license text is available in the `LICENSE` file.
