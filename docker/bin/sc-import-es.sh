#!/bin/bash
set -exo pipefail

php /vagrant/bin/console UpdateSearchCommand --environment=dev
php /vagrant/bin/console UpdateSearchLoreCommand
