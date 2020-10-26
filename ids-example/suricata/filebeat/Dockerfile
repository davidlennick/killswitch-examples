FROM ubuntu

WORKDIR /etc/suricata

RUN apt update && \ 
    apt install -y software-properties-common wget apt-transport-https

# suricata
RUN add-apt-repository -y ppa:oisf/suricata-stable
RUN apt update && apt install -y suricata
ADD suricata.yaml /etc/suricata/suricata.yaml
ADD capture-filter.bpf /etc/suricata/
ADD enable.conf /etc/suricata/
ADD entrypoint.sh /etc/suricata/

# # filebeat... this should be split out later
# # replaced this with volumes... but, it's here if you need it!
# RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
# RUN echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list
# RUN apt update && apt install -y filebeat
# RUN filebeat modules enable suricata
# ADD filebeat.yml /etc/filebeat

# #  change perms here because lazy
# RUN chmod go-w /etc/filebeat/filebeat.yml   

# add the example dashboards
RUN rm -rf /var/lib/apt/lists/* && apt-get clean && apt autoremove -y

# Start the Suricata/Filebeat service when the container is started
ENTRYPOINT /etc/suricata/entrypoint.sh 
