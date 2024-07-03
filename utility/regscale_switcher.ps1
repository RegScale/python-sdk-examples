# Check if ConsoleGuiTools is installed

<#
.SYNOPSIS
    Simple script to switch between different regscale instances using the CLI 
.EXAMPLE
    C:\PS>./regscale_switcher.ps1  
    This will pop up a list of domains to select from and then login to the selected domain
    update regscale.txt with the list of domains
.NOTES
    Author: Bryan Eaton
    Date:   July 3, 2024    
#>


if (-not (Get-Module -ListAvailable -Name Microsoft.PowerShell.ConsoleGuiTools)) {
    Write-Host "ConsoleGuiTools is not installed. Please install it using the following command:"
    Write-Host "Install-Module Microsoft.PowerShell.ConsoleGuiTools"
    exit 1
}


# Validate that the environment variables are set
if (!$env:REGSCALE_USERNAME) {
    Write-Host "REGSCALE_USERNAME is not set"
    # How to set environment variables in PowerShell
    Write-Host "To set the environment variables, use the following command:"
    Write-Host "\$env:REGSCALE_USERNAME = 'your_username'"
    exit 1
}

if (!$env:REGSCALE_PASSWORD) {
    Write-Host "REGSCALE_PASSWORD is not set"
    Write-Host "To set the environment variables, use the following command:"
    Write-Host "\$env:REGSCALE_PASSWORD = 'your_password'"
    exit 1
}

# Remove the environment variables if they exist
if ($env:REGSCALE_TOKEN) {
    Remove-Item Env:\REGSCALE_TOKEN
}

if ($env:REGSCALE_DOMAIN) {
    Remove-Item Env:\REGSCALE_DOMAIN
}

# Get the directory of the script
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Definition

# File containing the list of domains
$DOMAINS_FILE = Join-Path $SCRIPT_DIR "regscale.txt"

# Use Out-GridView to select a domain
$env:REGSCALE_DOMAIN = Get-Content $DOMAINS_FILE | Out-ConsoleGridView -OutputMode Single

# print REGSCALE_DOMAIN
# Write-Host "REGSCALE_DOMAIN: $env:REGSCALE_DOMAIN"

# login to regscale
regscale login --username $env:REGSCALE_USERNAME --domain $env:REGSCALE_DOMAIN
