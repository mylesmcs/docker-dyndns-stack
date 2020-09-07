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
NSDOMAIN=
DDNSDOMAIN=

# -------------------------------
# Port bindings
# -------------------------------
HTTP=80
HTTPS=443
DNS=53

# -------------------------------
# Maria database config
# -------------------------------
DBNAME=
DBUSER=
DBPASS=
DBROOTPASS=

EOF