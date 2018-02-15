#!/usr/bin/python

import requests
import argparse
import sys
import json
from pprint import pprint

JSESSIONID = "Be4IWCo8QONeMjrvdTjeFQ"
lgtm_long_session = "761e071693a6bf51619ae10e567d9221f2c0a161c409e7a0b37f09fd4a8624d608f474f04d6ee2bc82f0ca95ce2ffcc90ae305f694638e6ab0e4bdef9e54eeed"
nonce = "c21f09d757e9c940f06e3645f63a09dcc4c359ad25b41c2076e5ba98b7f854ad28b3d55836437ccad6f14091acab3d6fe665cfd4742caab8efaa8bb635485d6f"
apiVersion = "61cc875ccc188f3805e0d7c033cd57903a4ea260"

projectKeys="[1878170062]"

cookies = {'JSESSIONID': JSESSIONID, 'lgtm_long_session': lgtm_long_session}

def runQuery(filename):
    print >> sys.stderr, "[Running Query '%s' ... ]" % filename

    with open(filename) as f:
        ql = f.read()

    r = requests.post("https://lgtm.com/internal_api/v0.2/runQuery",
                  data={
                          'lang': 'java',
                          'projectKeys': projectKeys,
                          'queryString': ql,
                          'guessedLocation': "",
                          'nonce': nonce,
                          'apiVersion': apiVersion
                      },
                      cookies=cookies)
    return r

def getCustomQueryRunResults(filename):
    print >> sys.stderr, "[Getting Query Run Results from '%s' ... ]" % filename

    with open(filename) as f:
        run = f.read()

    js = json.loads(run)
    key = js['data']['runs'][0]['key']
    print >> sys.stderr, "[Query Run Results Key '%s' ... ]" % key

    r = requests.get("https://lgtm.com/internal_api/v0.2/getCustomQueryRunResults", params = {
        'startIndex': 0,
        'count': 3,
        'unfiltered': 'false',
        'queryRunKey': key,
        'nonce': nonce,
        'apiVersion': apiVersion
    }, cookies=cookies)
    return r

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Run QL query.')
    parser.add_argument('action', choices=['run', 'results'])
    parser.add_argument('infile', metavar='infile', help='Input file to run')
    parser.add_argument('outfile', metavar='outfile', help='Output file to run')
    args = parser.parse_args()

    if args.action == 'run':
        r = runQuery(args.infile)
    elif args.action == 'results':
        r = getCustomQueryRunResults(args.infile)

    print >> sys.stderr, "[Status Code: %s (%s)]" % (r.status_code, r.reason)

    if r.status_code == 200:
        outjson = json.dumps(json.loads(r.text), indent=2)
        with open(args.outfile, "w") as outfile:
            outfile.write(outjson)
    else:
        raise Warning(r, r.text)
