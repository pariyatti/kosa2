#!/usr/bin/env bash
set -e
set -x

# **/*.rb is easier, but MacOS Bash doesn't include globstar by default
# and we don't want to assume the user executing this script is on zsh
grep -inr --include \*.rb --include \*.rake "TODO:" .
