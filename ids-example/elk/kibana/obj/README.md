https://www.elastic.co/guide/en/kibana/current/saved-objects-api-resolve-import-errors.html



curl -H "Content-Type: application/json" -XDELETE 127.0.0.1:9200/*


## import
curl -X POST "localhost:5601/api/saved_objects/_import" -H "kbn-xsrf: true" --form file=@suricata.ndjson

curl -X POST "localhost:5601/api/saved_objects/_import" -H "kbn-xsrf: true" --form file=@suricata.ndjson

curl -X POST "localhost:5601/api/saved_objects/_export" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -o suricata.ndjson




https://github.com/elastic/beats/tree/master/x-pack/filebeat/module/suricata/_meta/kibana/7/dashboard
