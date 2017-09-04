#!/bin/bash
# This startup script is needed, because otherwise
# the ip address of the backend in the nginx.conf
# will be wrong! For details, read Readme.md!

sed -i -e "s/BACKENDIP/$1/g" nginx/conf/nginx.conf
docker-compose up

