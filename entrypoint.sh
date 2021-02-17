#!/bin/bash

if [[ ! -f /conf/.templated ]]; then
    mkdir -p /conf/logs
    cp -r /usr/local/nginx/conf/* /conf/
    sed -i "s/SRV_HOSTNAME/$(cat /etc/hostname)/g" /var/www/html/index.html
    touch /conf/.templated
fi

if [[ ! -d /tmp/hls ]]; then
    mkdir -p /tmp/hls
fi

exec /usr/local/nginx/sbin/nginx -p /conf -c /conf/nginx.conf -g 'daemon off;'
