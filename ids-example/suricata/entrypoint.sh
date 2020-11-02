#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'

red_print () {
  echo -e "\n\n${RED}$1\n########################################################${NC}\n\n"
}

red_print "Updating suricata sources..." 

suricata-update update-sources 

suricata-update enable-source et/open 

suricata-update --enable-conf /etc/suricata/enable.conf --local=/var/lib/suricata/rules/killswitch.rules

red_print "Starting suricata..." 
suricata -D -v -i $IF 

red_print "Ouput logs to console..." 
tail -F /var/log/suricata/suricata.log



