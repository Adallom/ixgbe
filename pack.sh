#! /usr/bin/env bash

NAME=ixgbe
VERSION=3.18.7-adallom
DESCRIPTION="Linux driver for the Intel(R) 10GbE PCI Express Family of Server Adapters."
VENDOR="Intel Corporation"
URL="http://www.intel.com/network/connectivity/products/server_adapters.htm"
LICENSE="GPL"
MAINTAINER="arie@adallom.com"

TEMPDIR=$(mktemp -d)
echo "Creating $TEMPDIR"

make -C src clean
make -C src

make -C src INSTALL_MOD_PATH=$TEMPDIR  install
install -D -m 644 modprobe-options-ixgbe.conf $TEMPDIR/etc/modprobe.d/ixgbe.conf

fpm -t deb -s dir --name "$NAME" \
    -v "$VERSION" \
    -C $TEMPDIR \
    --maintainer "$MAINTAINER" \
    --vendor "Adallom Labs" \
    --license "$LICENSE" \
    --url "http://bitbucket.org/adallom/ixgbe" \
    --deb-field "Branch: $(git rev-parse --abbrev-ref HEAD)" \
    --deb-field "Commit: $(git rev-parse HEAD)" \
    --description "$DESCRIPTION" \
    --deb-field "Original-Maintainer: Intel Corporation" \
    --deb-field "Original-Homepage: $URL" \
    --after-install "DEBIAN/refresh_depmod" \
    --after-remove "DEBIAN/refresh_depmod" \
     .

echo "Removing $TEMPDIR"
rm -rf $TEMPDIR
