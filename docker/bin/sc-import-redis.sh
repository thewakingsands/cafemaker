#!/bin/bash
set -eo pipefail

/usr/bin/php /vagrant/bin/console SaintCoinachJsonCacheCommand


/usr/bin/php /vagrant/bin/console SaintCoinachRedisCommand --content=ENpcBase -q

for (( i = 0; i <= 100; ++i )); do
  start_point=$(( $i * 10 ))

  echo " --------- Loop: $i / 22 - chunk: $start_point ------------------------------------"

  /usr/bin/php /vagrant/bin/console SaintCoinachRedisCommand --start=$start_point --count=10 -q

done
