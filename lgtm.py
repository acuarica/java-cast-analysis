#!/usr/bin/python

import requests
import argparse
import sys
import json
from pprint import pprint

JSESSIONID = "ymSF5y1mn0HsGzq1JgP_Ww"
lgtm_long_session = "761e071693a6bf51619ae10e567d9221f2c0a161c409e7a0b37f09fd4a8624d608f474f04d6ee2bc82f0ca95ce2ffcc90ae305f694638e6ab0e4bdef9e54eeed"
nonce = "6b5ad4e2de6c9cbfd48fb83161f358dea328ad4d9ae438b95e8dbfa89f640a4ccad4af05b9fb6cc14f123c472a9001fc670432885fafe9ddfeba93dad1336f4b"
apiVersion = "3b7bf8713a07f49f4d37c41dc83d00e24ed13f37"

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
