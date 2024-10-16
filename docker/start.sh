#!/bin/sh

export NODE_ENV=production

./setup-sync.sh

crond &

mkdir -p /run/nginx
cd /src/backend
npm start &
nginx -g 'daemon off;'
