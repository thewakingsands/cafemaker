#!/bin/bash
set -exo pipefail

php /vagrant/bin/console UpdateSearchCommand --environment=dev --full=1
php /vagrant/bin/console UpdateSearchLoreCommand
