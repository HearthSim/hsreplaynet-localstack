#!/bin/bash

vagrant up &&
vagrant ssh -c "/bin/bash /home/vagrant/hsreplay.net/scripts/provision_run.sh"
