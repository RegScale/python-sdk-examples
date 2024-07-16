#!/bin/bash

SSP=$1
NESSUS_FOLDER_PATH=$2
DOMAIN='https://regscale.example.com'

# Throw exception if SSP is not provided

if [ -z "$SSP" ]
then
    echo "SSP is required as first argument"
    echo "Usage: ./job.sh SSP NESSUS_FOLDER_PATH (optional)"
    exit 1
fi


export LOGLEVEL=DEBUG
# Assume we already have our envionment variables set up

# LOGIN

regscale login --username $REGSCALE_USERNAME --password $REGSCALE_PASSWORD --domain $DOMAIN

# sync assets

regscale tenable io sync_assets --regscale_ssp_id $SSP

# Sync vulns

regscale tenable io sync_vulns --regscale_ssp_id $SSP

# Sync Nessus Folder if available

# if nessus folder folder_path is provided, it will sync all nessus folders

if [ -z "$NESSUS_FOLDER_PATH" ]
then
    echo "done."
else
    regscale tenable io sync_nessus_folder --regscale_ssp_id $SSP --folder_path $NESSUS_FOLDER_PATH
    echo "done."
fi
