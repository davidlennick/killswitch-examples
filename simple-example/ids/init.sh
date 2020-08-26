#!/bin/bash

sudo -P rm -r data
mkdir -p data/elk/log
mkdir -p data/elk/kibana
mkdir -p data/suricata/log
sudo -P chmod -R a+rwX data/
sudo -P chmod -R a+rwX logstash.conf