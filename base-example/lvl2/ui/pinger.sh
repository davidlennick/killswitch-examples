#!/bin/bash
while sleep 1; do echo "hi" && curl $API_URI/tasks; done