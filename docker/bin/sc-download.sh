#!/bin/bash
set -xeo pipefail
SC_DOWNLOAD_PREFIX="${SC_DOWNLOAD_PREFIX:-https://github.com}"

wget $SC_DOWNLOAD_PREFIX/xivapi/SaintCoinach/releases/latest/download/SaintCoinach.Cmd.zip -O /vagrant/data/SaintCoinach.Cmd.zip
mkdir -p /vagrant/data/SaintCoinach.Cmd
cd /vagrant/data/SaintCoinach.Cmd

if [ -e /vagrant/data/SaintCoinach.Cmd/ex.json ]; then
  rm /vagrant/data/SaintCoinach.Cmd/ex.json
fi

unzip -o /vagrant/data/SaintCoinach.Cmd.zip

php /cafemaker/bin/ex.php
