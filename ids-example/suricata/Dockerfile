FROM ubuntu:latest

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

# add killswitch rules
ADD killswitch.rules /var/lib/suricata/rules/

# cleanup
RUN rm -rf /var/lib/apt/lists/* && apt-get clean && apt autoremove -y

# Start the Suricata/Filebeat service when the container is started
ENTRYPOINT /etc/suricata/entrypoint.sh 
