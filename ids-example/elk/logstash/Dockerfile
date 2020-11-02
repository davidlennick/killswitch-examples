# https://github.com/elastic/logstash-docker
FROM docker.elastic.co/logstash/logstash:7.8.0

# Add your logstash plugins setup here
# Example: RUN logstash-plugin install logstash-filter-json

RUN logstash-plugin install logstash-filter-translate
RUN logstash-plugin install logstash-output-syslog
RUN logstash-plugin install logstash-filter-geoip

USER root
RUN yum install wget bzip2 -y
RUN wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \ 
      rpm -ivh epel-release-latest-7.noarch.rpm && \ 
      yum install aria2 -y

ADD update.sh /usr/bin
RUN mkdir -p /etc/listbot && \
    chown -R logstash:logstash /etc/listbot && \
    chmod 755 /usr/bin/update.sh

USER logstash

HEALTHCHECK --retries=10 CMD curl -s -XGET 'http://127.0.0.1:9600'

CMD update.sh && exec /usr/share/logstash/bin/logstash -f /usr/share/logstash/config/logstash.conf --config.reload.automatic --java-execution 
# --debug