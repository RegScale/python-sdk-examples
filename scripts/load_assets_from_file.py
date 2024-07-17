#!/usr/bin/env python3
import csv
import os
import sys 
from regscale.models.regscale_models.asset import Asset
from regscale.core.app.internal.login import login

# Assert there is one argument
assert len(sys.argv) == 3, "Usage: python load_assets_from_file.py <file_path> <ssp_id>"

FILE_PATH = sys.argv[1]
SSP_ID = sys.argv[2]

# You can hardcode or pass from environment variables
REGSCALE_USERNAME=os.getenv('REGSCALE_USERNAME')
REGSCALE_PASSWORD=os.getenv('REGSCALE_PASSWORD')
REGSCALE_DOMAIN=os.getenv('REGSCALE_DOMAIN')

def login_to_regscale():
    # Login to Regscale
    login(str_user=REGSCALE_USERNAME, str_password=REGSCALE_PASSWORD, host=REGSCALE_DOMAIN)


def load_assets_from_file(file_path, ssp_id):
    assets = []
    with open(file_path, newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            asset = Asset(
                parentId=ssp_id, parentModule='securityplans',
                assetType='Other', otherTrackingId=row['Asset ID'], name=row['Asset Name'], ipAddress=row['IP Address'],macAddress=row['MAC Address'], assetCategory='Hardware', status='Active (On Network)')
            assets.append(asset)
    return assets


if __name__ == '__main__':
    login_to_regscale()
    assets = load_assets_from_file(FILE_PATH, SSP_ID)
    existing_assets = Asset.get_all_by_parent(SSP_ID, 'securityplans')
    for asset in assets:
        if asset not in existing_assets:
            print(f"Creating asset {asset.name}")
            asset.create()
        else:
            print(f"Updating asset {asset.name}")
            existing_asset = existing_assets[existing_assets.index(asset)]
            existing_asset.save()
