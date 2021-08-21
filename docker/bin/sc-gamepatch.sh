#!/bin/bash
set -xeo pipefail
SC_CLONE_PREFIX="${SC_CLONE_PREFIX:-https://github.com}"

rm -rf /vagrant/data/ffxiv-datamining-patches
mkdir -p /vagrant/data/ffxiv-datamining-patches
cd /vagrant/data/ffxiv-datamining-patches
svn co $SC_CLONE_PREFIX/xivapi/ffxiv-datamining-patches/trunk/patchdata
