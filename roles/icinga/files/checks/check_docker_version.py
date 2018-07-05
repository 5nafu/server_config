#!/usr/bin/env python

import requests
import argparse
import logging
from sys import exit


def parse_arguments(argv=None):
    description = """
    Get the latest release from Github and check if there is an image with this tag on docker hub.
    """
    parser = argparse.ArgumentParser(description=description)
    parser.add_argument('-p', '--githubproject', help="Github project in the form 'user/repo'", required=True)
    parser.add_argument('-d', '--dockerimage', help="Docker image in the form 'user/image'", required=True)
    parser.add_argument(
        '-v',
        '--verbose',
        action='store_const',
        const=logging.INFO,
        default=logging.WARNING,
        dest='loglevel'
    )
    args = parser.parse_args(argv)
    return args


def get_latest_github_release(repository):
    return requests.get('https://api.github.com/repos/{0}/releases/latest'.format(repository)).json()['tag_name']


def docker_tag_exists(repository, tag, logger=None):
    logger = logger or logging.getLogger(__name__)
    url = "https://hub.docker.com/v2/repositories/%s/tags/"
    r = requests.get(url % repository)
    dh_tags = [dh_tag['name'] for dh_tag in r.json()['results']]
    logger.info("Got Tags from Docker:" + ",".join(dh_tags))
    return tag in dh_tags


def main():
    args = parse_arguments()
    logging.basicConfig(level=args.loglevel)
    logger = logging.getLogger('check_docker_version')
    github_release = get_latest_github_release(args.githubproject)
    logger.info("Latest Github release: '%s'" % github_release)
    if docker_tag_exists(args.dockerimage, github_release, logger):
        print("OK - Found Tag '%s' in taglist, build is current" % github_release)
        return True
    else:
        print("CRITICAL - Tag '%s' not found in taglist, build to old" % github_release)
        return False


if __name__ == "__main__":
    try:
        if main():
            exit(0)
        else:
            exit(2)
    except Exception as e:
        print("WARNING - Exception thrown")
        print(e)
        exit(1)
