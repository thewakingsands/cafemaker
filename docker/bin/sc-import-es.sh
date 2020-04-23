#!/bin/bash
set -exo pipefail

php /vagrant/bin/console UpdateSearchCommand dev
php /vagrant/bin/console UpdateSearchLoreCommand dev
