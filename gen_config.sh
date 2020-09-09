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

read -p "Enter timezone [$(timedatectl | grep 'Time zone' |  grep -Po '(?<=\: ).*[^\s]')]: " timezone
timezone=${timezone:-$(timedatectl | grep 'Time zone' |  grep -Po '(?<=\: ).*[^\s]')}

read -p "Enter server domain [example.com]: " dnsdomain
dnsdomain=${dnsdomain:-example.com}

read -p "Enter dynamic dns domain [example.com]: " ddnsdomain
ddnsdomain=${ddnsdomain:-example.com}

read -p "Enter database username [ddns]: " dbuname
dbuname=${dbuname:-ddns}

read -p "Enter database user password: " dbupass
dbupass=${dbupass:-"$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-12})"}

read -p "Enter database root password: " dbrpass
dbrpass=${dbrpass:-"$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32})"}

read -p "Container network IPv4 [10.10.0.x]: " containernet
containernet=${containernet:-10.10.0}

cat << EOF > ddns.conf
# -------------------------------
# Dynamic DNS Dockerisec config
# -------------------------------

TZ=$timezone

DNS_DOMAIN=$dnsdomain
DDNS_DOMAIN=$ddnsdomain

CONTAINER_NETWORK=$containernet

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
DB_USER=$dbuname
DB_PASS=$dbupass
DB_ROOT_PASS=$dbrpass

EOF