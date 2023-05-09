#!/bin/bash
set -xeo pipefail
SC_CLONE_PREFIX="${SC_CLONE_PREFIX:-https://github.com}"
SC_PATCHDATA_DIR=/vagrant/data/ffxiv-datamining-patches

rm -rf "$SC_PATCHDATA_DIR"
git clone -n --depth=1 --filter=tree:0 "${SC_CLONE_PREFIX}/xivapi/ffxiv-datamining-patches" "$SC_PATCHDATA_DIR"
git -C "$SC_PATCHDATA_DIR" sparse-checkout set --no-cone patchdata
git -C "$SC_PATCHDATA_DIR" checkout
