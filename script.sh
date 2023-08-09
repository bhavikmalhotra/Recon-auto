#!/bin/bash

domain=$1
rm website_data.json
rm -rf output/$domain
mkdir -p output/$domain/subdomain/up

#Here we have used 4 latest tools to find subdomains and also a crt.sh query to filter out domains for our target
echo "[+] TARGET: $domain"
echo "[+] Subdomain Enumeration!! Results will be saved in the output/$domain/subdomain directory"

echo "[+] Running Subfinder to find subdomains"
subfinder -d $domain  --silent -o output/$domain/subdomain/subfinder.txt 1>/dev/null

echo "[+] Running Assetfinder"
assetfinder -subs-only $domain > output/$domain/subdomain/assetfinder.txt

echo "[+] Runnning findomain"
findomain -t $domain > output/$domain/subdomain/findomain.txt

echo "[+] Running Amass Scan"
amass enum -passive -d $domain -o output/$domain/subdomain/amass_sub.txt 1>/dev/null

echo "[+] Running crt.sh querry to filter out subdomains"
curl -s "https://crt.sh/?q=%25.$domain&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u > output/$domain/subdomain/crtsub.txt


#Now we need to find out the unique websites among these
cat output/$domain/subdomain/*.txt > output/$domain/subdomain/allsub.txt
cat output/$domain/subdomain/allsub.txt | sort -u | grep $domain | tee -a output/$domain/subdomain/all_subdomains.txt


unique_sub=$(cat output/$domain/subdomain/all_subdomains.txt | wc -l)
echo "[+] UNIQUE SUBDOMAINS FOUND: $unique_sub"


#Now we need to check what all sites are up so we will be using https for this
httpx -l output/$domain/subdomain/all_subdomains.txt -threads 150 -silent -o output/$domain/subdomain/up/live_subdomains.txt 1>/dev/null

up_subdomains=$(cat output/$domain/subdomain/up/live_subdomains.txt | wc -l)
echo "[+] UP SUBDOMAINS: $up_subdomains"

#Now We will try finding the ip address of these websites
#we need to clean the trailing http:// using awk
#cat "output/$domain/subdomain/up/live_subdomains.txt" | awk -F "//" '{print $2}' > output/$domain/subdomain/clean_sub.txt
input_file="output/$domain/subdomain/up/live_subdomains.txt"

#We will be using a python script to find the ipp address and save the output in a json file for easy analysis
echo "[+] Finding the Ip address and the tech stack "
python3 helper.py -f $input_file

echo "[+] OPEN website_data.json TO CHECK RESULTS"
