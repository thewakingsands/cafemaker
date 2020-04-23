#!/bin/bash
set -eo pipefail

php /vagrant/bin/console SaintCoinachJsonCacheCommand

count=$(ls /vagrant/data/gamedocuments/json | wc -l)

for (( i = 0; i <= count; ++i )); do
  echo "# $i / $count"
  php /vagrant/bin/console SaintCoinachRedisCommand $i 1 1 -q
done
