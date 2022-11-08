#!/usr/bin/env python3

import socket
import argparse

def do_lookup(ip):
    try:
        host = socket.gethostbyaddr(ip)
        if host is not None:
            print(f'{ip} : {host[0]}')
            domains.append(host[0])
    except socket.herror:
        pass

parser = argparse.ArgumentParser(description='Resolve IPs to Domains')
parser.add_argument('-i', '--ip', help='Resolve a single IP')
parser.add_argument('-l', '--list', help='Resolve a list oof IPs')
parser.add_argument('-o', '--output', help='Output file (default: domains.txt', default='domains.txt')
parser.add_argument('-h', '--help', help='Print help')
args = parser.parse_args()

domains = list()

if args.ip:
    do_lookup(args.ip)
elif args.list:
    with open(args.list) as f:
        lines = f.readlines()
        
        for line in sorted(lines):
            do_lookup(line.strip())
elif args.help:
    parser.print_help()
elif args.ip and args.list:
    parser.print_help()
else:
    parser.print_help()
with open(args.output, 'w+') as f:
    for domain in domains:
        f.write(domain + '\n')
