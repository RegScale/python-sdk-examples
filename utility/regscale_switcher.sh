#!/usr/bin/env fish


# Validate that the environment variables are set
if test -z "$REGSCALE_USERNAME"
    echo "REGSCALE_USERNAME is not set"
    exit 1
end

if test -z "$REGSCALE_PASSWORD"
    echo "REGSCALE_PASSWORD is not set"
    exit 1
end

set -e REGSCALE_TOKEN
set -e REGSCALE_DOMAIN

# Get the directory of the script
set SCRIPT_DIR (dirname (status -f))


# File containing the list of domains
set DOMAINS_FILE "$SCRIPT_DIR/regscale.txt"

# Use fzf to select a domain
set REGSCALE_DOMAIN (cat $DOMAINS_FILE | fzf)

# login to regscale 
regscale login --username $REGSCALE_USERNAME --domain $REGSCALE_DOMAIN
