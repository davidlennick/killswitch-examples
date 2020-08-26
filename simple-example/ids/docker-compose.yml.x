version: '3.8'
# https://github.com/dtag-dev-sec/tpotce/

services:
  elasticsearch:
    image: dtagdevsec/elasticsearch:2006
    container_name: elasticsearch
    restart: always
    environment:
     - bootstrap.memory_lock=true
     - ES_JAVA_OPTS=-Xms2048m -Xmx2048m
     - ES_TMPDIR=/tmp
    cap_add:
     - IPC_LOCK
    ulimits:
      memlock:
        soft: -1
        hard: -1
      nofile:
        soft: 65536
        hard: 65536
    #mem_limit: 4g
    ports:
     - "127.0.0.1:8100:9200"
    volumes:
     - ./data:/data
  
  kibana:
    image: dtagdevsec/kibana:2006
    container_name: kibana
    restart: always
    stop_signal: SIGKILL
    depends_on:
      - elasticsearch
    # volumes:
    #   - ./data:/usr/share/kibana
    ports:
      - "127.0.0.1:8101:5601"

  ## Logstash service
  logstash:
    image: dtagdevsec/logstash:2006
    container_name: logstash
    restart: always
    environment:
      - LS_JAVA_OPTS=-Xms2048m -Xmx2048m
    depends_on:
      - elasticsearch
    volumes:
      - ./data:/data
      - ./logstash.conf:/etc/logstash/conf.d/logstash.conf

  suricata:
    image: dtagdevsec/suricata:2006
    restart: always
    #privileged: true
    network_mode: host
    cap_add:
      - NET_ADMIN
      - SYS_NICE
      - NET_RAW
    environment:  # For ET Pro ruleset replace "OPEN" with your OINKCODE
      - OINKCODE=OPEN
      - IF=enp37s0
    volumes:
      - ./data/suricata/log:/var/log/suricata
    command: /bin/ash -c 'export SURICATA_CAPTURE_FILTER=$$(/usr/bin/update.sh $$OINKCODE) && printenv && suricata -v -F $$SURICATA_CAPTURE_FILTER -i $$IF'


