#!/usr/bin/python3
import sys
import os
import time
import argparse
import logging
from pprint import pprint


import docker
from docker.models.containers import Container


def parse_args():
    parser = argparse.ArgumentParser(description='Killswitch CLI interface')
    parser.add_argument('level',
                        type=int,
                        help='set the operation level')
    parser.add_argument("-v", "--verbose",
                        help="increase output verbosity",
                        default=False,
                        action="store_true")
    return parser.parse_args()


def find_current_level_stats(c_list: [Container]):
    curr_max = 0
    curr_min = sys.maxsize
    curr_active = 0

    for c in c_list:
        if 'level' in c.attrs['Labels']:
            curr_val = int(c.attrs['Labels']['level'])

            if curr_val > curr_max:
                curr_max = curr_val

            if curr_val < curr_min:
                curr_min = curr_val

            if curr_val > curr_active and c.attrs['State'] == 'running':
                curr_active = curr_val

    return curr_min, curr_max, curr_active


def group_by_level(c_list: [Container]):
    grouped_c_lists = {}

    for c in c_list:
        if 'level' in c.attrs['Labels']:
            curr_val = int(c.attrs['Labels']['level'])
            if curr_val not in grouped_c_lists:
                grouped_c_lists[curr_val] = [c]
            else:
                grouped_c_lists[curr_val].append(c)

    return grouped_c_lists


def do_killswitch(c: Container, target_level: int):
    state_change = "none"

    if 'level' in c.attrs['Labels']:
        if int(c.attrs['Labels']['level']) <= target_level:
            if c.attrs['State'] != 'running':
                c.start()
                state_change = "started"
        else:
            if c.attrs['State'] == 'running':
                c.kill()
                state_change = "killed"

    return c, state_change


def wait_until_all_running(client: docker.DockerClient, c_list):

    done = False
    while not done:

        done = True

        for c in c_list:
            curr_c = client.containers.get(c.id)
            # pprint(vars(curr_c))
            if not curr_c.attrs['State']['Running'] or curr_c.attrs['State']['Health']['Status'] != 'healthy':
                logging.debug("waiting on {}".format(curr_c.attrs['Name']))
                logging.debug("state: {}".format(
                    curr_c.attrs['State']['Status']))
                logging.debug("health: {}".format(
                    curr_c.attrs['State']['Health']['Status']))
                done = False

        if not done:
            time.sleep(1)


def killswitch(client: docker.DockerClient, target_level: int):

    # establish which levels is active, and the min/max levels available
    min_level, max_level, active_level = find_current_level_stats(
        client.containers.list(all=True, sparse=True))
    logging.info(
        "Min/max/active level: {}/{}/{}".format(min_level, max_level, active_level))

    # group the containers by their level
    grouped_c_lists = group_by_level(
        client.containers.list(all=True, sparse=True))

    # start from lower -> higher levels
    if target_level >= active_level:
        if target_level > max_level:
            logging.info(
                "Target level above maximum available level. Verifying containers are started.")

        if target_level == active_level:
            logging.info(
                "Target level is equal to current level. Verifying containers are started.")

        for level in sorted(grouped_c_lists.keys()):
            res = [do_killswitch(c, target_level)
                   for c in grouped_c_lists[level]]

            if level <= target_level:
                wait_until_all_running(client, grouped_c_lists[level])

            logging.info("Level {} containers state change: ".format(level))
            for k, v in res:
                logging.info("container: {}    state: {}".format(
                    k.attrs['Names'][0], v))

    # start from higher -> lower level
    else:
        for level in sorted(grouped_c_lists.keys(), reverse=True):
            res = [do_killswitch(c, target_level)
                   for c in grouped_c_lists[level]]
            logging.info("Level {} containers state change: ".format(level))
            for k, v in res:
                logging.info("container: {}    state: {}".format(
                    k.attrs['Names'][0], v))


if __name__ == '__main__':

    args = parse_args()
    print(vars(args))
    
    if args.verbose:
        logging.basicConfig(level=logging.DEBUG)
        logging.debug("Debug logging enabled")
    else:
        logging.basicConfig(level=logging.INFO)
    client = docker.from_env()
    killswitch(client, args.level)
