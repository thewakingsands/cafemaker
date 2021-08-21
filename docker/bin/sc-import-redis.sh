#!/bin/bash
set -eo pipefail

/usr/bin/php /vagrant/bin/console SaintCoinachJsonCacheCommand

for i in {1..40}
do
  start_point=$(( $i * 25 ))

  echo " --------- Loop: $i / 40 - chunk: $start_point ------------------------------------"

  /usr/bin/php /vagrant/bin/console SaintCoinachRedisCommand --start=$start_point --count=25 --full=1 -q
done
