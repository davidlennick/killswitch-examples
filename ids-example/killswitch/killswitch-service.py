#!/usr/bin/python3

import json
import os
import time
import threading
import argparse
from pprint import pprint
import logging

import docker
import killswitch as ks

def parse_args():
    parser = argparse.ArgumentParser(
        description='Killswitch service interface')

    parser.add_argument('eve_path',
                        help='set the suricata eve.json file path')
    parser.add_argument('rule_path',
                        help='set the operation level config file path')
    parser.add_argument("-v", "--verbose",
                        help="increase output verbosity",
                        default=False,
                        action="store_true")


    return parser.parse_args()


def tail(stream_file):
    """ Read a file like the Unix command `tail`. Code from https://stackoverflow.com/questions/44895527/reading-infinite-stream-tail """
    stream_file.seek(0, os.SEEK_END)  # Go to the end of file

    while True:
        if stream_file.closed:
            raise StopIteration

        line = stream_file.readline()

        yield line


def listen_for_alerts(log_path, rules_json):
    """ Read log (JSON format) and insert data in db """
    
    client = docker.from_env()
    rules = rules_json["rules"]

    with open(log_path, "r") as log_file:
        for line in tail(log_file):            
            for level, criteria in rules.items():
              for c in criteria:
                if c in line:
                  logging.info("Heard alert!\nLevel: {} match:\n{} line:\n{}".format(level, c, line))
                  ks.killswitch(client, int(level))
    

if __name__ == "__main__":
    
    args = parse_args()
    
    if args.verbose:
        logging.basicConfig(level=logging.DEBUG, filename='killswitch.log')
        logging.debug("Debug logging enabled")
    else:
        logging.basicConfig(level=logging.INFO, filename='killswitch.log')
    logging.info("==========================")
    logging.info("Starting")
    logging.info("==========================")

    logging.debug("Checking rule_path...")
    if not os.path.exists(args.rule_path):
      logging.info("rule path does not exist!")

    
    logging.info("waiting for eve.json file...")
    while not os.path.exists(args.eve_path):      
      time.sleep(1)
    logging.info("eve.json file found, continuing...")

    logging.debug("Importing rules...")
    with open(args.rule_path, "r") as rule_file:
      rules_json = json.load(rule_file)

    logging.info("Starting listener on eve_path...")

    generator = threading.Thread(
        target=listen_for_alerts,
        args=(
          args.eve_path,
          rules_json,
        )
    )
    generator.start()
