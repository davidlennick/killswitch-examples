#!/bin/bash

kibana_url=http://127.0.0.1:5601

# wait for kibana
# curl -s -o /dev/null -w ''%{http_code}'' $kibana_url
while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' $kibana_url/status)" != "200" ]]; 
do 
  sleep 2; 
done

until curl -X POST -H "kbn-xsrf: true" \
        "$kibana_url/api/saved_objects/_import" \
        --form file=@/kibana_export.ndjson 
do
    sleep 2
    echo Retrying dashboard upload...
done

echo Uploaded dashboard