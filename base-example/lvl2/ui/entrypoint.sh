#!/bin/bash

API_URI="http://$API_ADDR:$API_PORT"

curl -X POST -d task='test task' -d 'is_complete=false' $API_URI/task
SERVER_SIDE_GET_BASE=$(curl $API_URI)
SERVER_SIDE_GET_TASKS=$(curl $API_URI/tasks)

echo $API_URI
sed -i "s@SERVER_SIDE_GET_BASE@$SERVER_SIDE_GET_BASE@" /usr/share/nginx/html/index.html
sed -i "s@SERVER_SIDE_GET_TASKS@$SERVER_SIDE_GET_TASKS@" /usr/share/nginx/html/index.html
exec $(which nginx) -c /etc/nginx/nginx.conf -g "daemon off;"