#!/usr/bin/env bash

exec /sbin/setuser root /usr/sbin/nginx -c /etc/nginx/nginx.conf >>/var/log/nginx.log 2>&1
