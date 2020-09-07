#!/usr/bin/env bash

set -o pipefail

if [ -f ddns.conf ]; then
read -r -p "Config already exists, overwrite? [y/N]" response
  case $response in
    [yY][eE][sS]|[yY])
      rm ddns.conf
      ;;
    *)
      exit 1
      ;;
  esac
fi


cat << EOF > ddns.conf
# -------------------------------
# Dynamic DNS Dockerisec config
# -------------------------------

TZ=

DNS_DOMAIN=
DDNS_DOMAIN=

CONTAINER_NETWORK=

# -------------------------------
# Port bindings
# -------------------------------
HTTP=80
HTTPS=443
DNS=53

# -------------------------------
# Maria database config
# -------------------------------
DB_NAME=
DB_USER=
DB_PASS=
DB_ROOT_PASS=

EOF