#!/bin/bash

echo "port: ${PORT}"

envsubst "\$PORT" < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

echo "Running supervisor"
/usr/bin/supervisord -c /etc/supervisord.conf