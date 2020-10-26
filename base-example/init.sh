#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'

red_print () {
    echo -e "\n\n${RED}$1\n########################################################${NC}\n\n"
}

red_print "########################################################\nWARNING!!!!!!!!!!!!!!!!\nThis will kill and destroy all containers and images."
read -p "Press enter to continue, Ctrl-C to exit"

red_print "Stopping containers..."
docker kill $(docker ps -q)

red_print "Removing all containers..."
docker rm $(docker ps -a -q)

red_print "Removing all images..."
docker rmi $(docker images -q)

red_print "Pruning..."
docker system prune -f --volumes --all

red_print "Installing Weave Scope"
sudo curl -L git.io/scope -o /usr/local/bin/scope
sudo chmod a+x /usr/local/bin/scope
scope launch

red_print "########################################################\nStarting docker-compose"
read -p "Press enter to continue"

docker-compose up --build --force-recreate --always-recreate-deps