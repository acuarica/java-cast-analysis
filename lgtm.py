#!/usr/bin/python

import requests
import argparse
import sys
import json
from pprint import pprint

JSESSIONID = "JViYho_sotNviPWGucFxgg"
lgtm_long_session = "761e071693a6bf51619ae10e567d9221f2c0a161c409e7a0b37f09fd4a8624d608f474f04d6ee2bc82f0ca95ce2ffcc90ae305f694638e6ab0e4bdef9e54eeed"
projectKeys="[1878170062]"
nonce = "7c46c3a740eb5c1744dae1c4b71ea4b3b2bc872e866895f01a5e954bb80a65816f9d63a76783dfd1b2a26a7f193e82a42e43cf63fcdb99a06a9c4bb02296b275"
apiVersion = "672a58deb8ba99a237ea301c277a6b18a64b1554"

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
    parser.add_argument('action', choices=['run', 'progress', 'results'])
    parser.add_argument('filename', metavar='filename', nargs='?', help='Filename to run')
    args = parser.parse_args()

    if args.action == 'run':
        r = runQuery(args.filename)
    elif args.action == 'results':
        r = getCustomQueryRunResults(args.filename)

    print >> sys.stderr, "[Status Code: %s (%s)]" % (r.status_code, r.reason)

    if r.status_code == 200:
        print(json.dumps(json.loads(r.text), indent=2))
    else:
        raise Warning(r)
        print r
