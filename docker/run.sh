#!/usr/bin/env bash

sed -i "s/%fpm-ip%/$FPM_PORT_9000_TCP_ADDR/" /etc/nginx/nginx.conf

/sbin/my_init
