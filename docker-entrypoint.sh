#!/bin/sh

set -e

mkdir -p -m 0750 /run/nginx

if [ "$(id -u)" = "0" ]; then
  if [ -n "$UID" ] && [ ! "$UID" = "$(id nginx -u)" ]; then
    usermod -u "$UID" nginx
  fi

  if [ -n "$GID" ] && [ ! "$GID" = "$(id nginx -g)" ]; then
    groupmod -g "$GID" nginx
  fi

  chown -R nginx:nginx \
    /etc/letsencrypt \
    /run/nginx \
    /var/lib/nginx \
    /var/lib/letsencrypt \
    /var/log/nginx
    /var/log/letsencrypt

  exec gosu nginx "$@"
else
  exec "$@"
fi

