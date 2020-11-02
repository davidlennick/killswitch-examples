#!/bin/bash

rm killswitch.log
touch killswitch.log
/app/killswitch-service.py /var/log/suricata/eve.json /app/rules.json &

tail -F /app/killswitch.log