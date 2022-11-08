#!/bin/bash

# Provide domain
SUBS=$1

source ~/.profile
subjack -w $SUBS -timeout 30 -o results.txt -ssl -c ~/go/src/github.com/haccer/subjack/fingerprints.json -v
