#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: ./run_all_project_discovery.sh <domain>"
    exit 1
fi

domain=$1

# Subfinder - Subdomain discovery
echo "Running subfinder for domain $domain..."
subfinder -d $domain -o subfinder_$domain.txt

# HTTPX - HTTP probing
echo "Running httpx on discovered subdomains..."
cat subfinder_$domain.txt | httpx -o httpx_$domain.txt

# Nuclei - Vulnerability scanning
echo "Running nuclei on discovered subdomains..."
nuclei -l httpx_$domain.txt -o nuclei_$domain.txt

# Interlace - Parallelizing tasks
echo "Running interlace with example tasks (change tasks as needed)..."
interlace -tL subfinder_$domain.txt -threads 10 -c "echo 'Running task on _target_'" -v

# Notify - Notifications
echo "Sending notifications for discovered subdomains and vulnerabilities..."
notify --data subfinder_$domain.txt --webhook-url "https://your-webhook-url.com"

# Chaos - Publicly exposed records
echo "Running chaos on the domain $domain..."
chaos -d $domain -o chaos_$domain.txt

# DNSX - DNS query and resolution
echo "Running dnsx on discovered subdomains..."
dnsx -l subfinder_$domain.txt -o dnsx_$domain.txt

echo "All tasks completed."
