#!/bin/bash
rm -rf /vagrant/data/ffxiv-datamining-patches
mkdir -p /vagrant/data/ffxiv-datamining-patches
cd /vagrant/data/ffxiv-datamining-patches
svn co https://github.com/xivapi/ffxiv-datamining-patches/trunk/patchdata
