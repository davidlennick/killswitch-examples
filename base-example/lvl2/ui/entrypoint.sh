#!/bin/bash

API_URI="http://$API_ADDR:$API_PORT"

attempt_counter=0
max_attempts=10

until $(curl --output /dev/null --silent --head --fail $API_URI); do
     if [ ${attempt_counter} -eq ${max_attempts} ];then
      echo "Max attempts reached"
      exit 1
    fi
    printf '.'
    sleep 3
done

curl -X POST -d task='test task' -d 'is_complete=false' $API_URI/task
SERVER_SIDE_GET_BASE=$(curl $API_URI)
SERVER_SIDE_GET_TASKS=$(curl $API_URI/tasks)

echo $API_URI
sed -i "s@SERVER_SIDE_GET_BASE@$SERVER_SIDE_GET_BASE@" /usr/share/nginx/html/index.html
sed -i "s@SERVER_SIDE_GET_TASKS@$SERVER_SIDE_GET_TASKS@" /usr/share/nginx/html/index.html
exec $(which nginx) -c /etc/nginx/nginx.conf -g "daemon off;"