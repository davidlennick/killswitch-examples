#!/bin/bash
while sleep 1; do curl $API_ADDR:$API_PORT/tasks; done