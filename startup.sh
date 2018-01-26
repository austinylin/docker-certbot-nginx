#!/bin/sh

# Disable all configs except certbot so we can do initial cert issuance
find /etc/nginx/conf.d/ ! -name 'certbot.conf' -type f -exec sh -c 'mv $1 "$1.disabled"' x {} \;

# Start nginx with our certbot config
service nginx start

# run certbot
certbot certonly --agree-tos --domains $CERTBOT_DOMAIN --email $CERTBOT_EMAIL --webroot --webroot-path /usr/share/nginx/html --non-interactive --test-cert

# unlock configs
find . -name '*.disabled' -type f -exec sh -c 'mv $1 `echo $1 | sed "s/.disabled$//"`' x {} \;

# restart to pickup new configs and ssl keys
service nginx restart

# start cron so we can rotate all the things
service cron start
