#!/bin/sh

if [ ! -d /var/db/devpi-server/ ]; then

  if [ -n "${DEVPISERVER_ROOT_PASSWD_FILE}" ]; then
    if [ -f "${DEVPISERVER_ROOT_PASSWD_FILE}" ]; then
      DEVPISERVER_ROOT_PASSWD="$(cat "${DEVPISERVER_ROOT_PASSWD_FILE}")"
      export DEVPISERVER_ROOT_PASSWD
    else
      echo "DEVPISERVER_ROOT_PASSWD_FILE (${DEVPISERVER_ROOT_PASSWD_FILE}) does not exists."
    fi
  elif [ -n "${DEVPISERVER_ROOT_PASSWD_HASH_FILE}" ]; then
    if [ -f "${DEVPISERVER_ROOT_PASSWD_HASH_FILE}" ]; then
      DEVPISERVER_ROOT_PASSWD_HASH="$(cat "${DEVPISERVER_ROOT_PASSWD_HASH_FILE}")"
      export DEVPISERVER_ROOT_PASSWD_HASH
    else
      echo "DEVPISERVER_ROOT_PASSWD_HASH_FILE (${DEVPISERVER_ROOT_PASSWD_HASH_FILE}) does not exists."
    fi
  fi

  echo "Prepare devpi before first start"
  devpi-init --configfile root/.devpi/config/devpi-server.yml
fi

echo "Run devpi server"
devpi-server --configfile root/.devpi/config/devpi-server.yml