#!/usr/bin/env python3

from re import sub
import argparse

# function to convert string to camelCase
def camelCase(string):
  string = sub(r"(_|-)+", " ", string).title().replace(" ", "")
  return string[0].lower() + string[1:]

parser = argparse.ArgumentParser(description='Convert a string to camel case')
parser.add_argument('-i', '--input', help='Input file')
parser.add_argument('-o', '--output', help='Output file (default: camel.txt', default='camel.txt')
parser.add_argument('-h', '--help', help='Print help')
args = parser.parse_args()

if args.input:
    with open(args.output, 'w+') as w:
        with open(args.input, 'r') as f: 
            content = f.readlines()
            for line in content:
                line=line.strip()
                w.write(line)
            
elif args.help:
    parser.print_help()
else:
    parser.print_help()
