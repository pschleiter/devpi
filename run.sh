#!/bin/sh

if [ ! -d /var/db/devpi-server/ ]; then
  echo "Prepare devpi before first start"
  devpi-init --configfile root/.devpi/config/devpi-server.yml
fi

echo "Run devpi server"
devpi-server --configfile root/.devpi/config/devpi-server.yml