#!/usr/bin/env python

import argparse
import json
import sys
from pathlib import Path

import semver


class Build:
    def __init__(self, data):
        if isinstance(data, dict):
            self.data = data
        else:
            self.data = json.loads(data.read_text(encoding='UTF-8'))

        self.name = self.data['name']
        self.version = self.data['version']
        self.python = self.data['python']
        self.os = self.data['os'].lower()
        self.mkl = self.data['mkl']

        self.key = '-'.join([self.name, self.version, self.python, self.os])

    def exclude(self, store):
        return (
            self.key in store and semver.compare(self.mkl, store[self.key]['mkl']) <= 0
        )

    def merge_with(self, store):
        store[self.key] = {'mkl': self.mkl}


def fetch_store(path):
    if isinstance(path, str):
        path = Path(path)
    return json.loads(path.read_text(encoding='UTF-8')) if path.exists() else {}


def check_builds(storepath, builds):
    store = fetch_store(storepath)
    for b in builds:
        if not Build(b).exclude(store):
            return sys.exit(0)
    sys.exit(1)


def merge_builds(storepath, builds):
    store = fetch_store(storepath)
    for b in builds:
        Build(b).merge_with(store)

    with storepath.open('w', encoding='UTF-8') as f:
        json.dump(store, f, indent=2, sort_keys=True)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Store build meta data')
    parser.add_argument('builds', nargs='+', help='input file(s)')
    parser.add_argument('-s', '--store', required=True, type=str, help='output file')
    parser.add_argument('--check', action='store_true', help='check if build exists')

    args = parser.parse_args()
    store = Path(args.store)
    builds = [Path(f) for f in args.builds]

    if args.check:
        check_builds(store, builds)
    else:
        merge_builds(store, builds)
