# https://github.com/elastic/kibana-docker
FROM docker.elastic.co/kibana/kibana:7.8.0

# Add your kibana plugins setup here
# Example: RUN kibana-plugin install <name|url>

COPY init.sh /
COPY upload-dash.sh /
COPY obj/kibana_export.ndjson /

CMD ["/init.sh"]

HEALTHCHECK --retries=10 CMD curl -s -XGET 'http://127.0.0.1:5601'