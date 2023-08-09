# Recon-auto
### This is an automatin script which is used to automate the process of finding subdomains, their ip address, and the technology stack used by them.

## Features
Find subdomains of any any domains, find their respective ip address and the technology they are using

## Methodology
- Used 4 tools for subdomain enumeration namely, Subfinder, Assetfinder, findomain and Amass along with crt.sh to retrive the subdomains of the target
- Saved the subdomains found by each tool.
- Sorted out the unique subdomains from all the subdomains found.
- Used httpx to find the subdomains which are up and running.
- Filterd out the up and running subdomains.
- Now to find out the ip address of these subdomains and the technology stack used the script `helper.py`.
- TO find ap address used the socket.gethostbyname() and 'http://ip-api.com' to find out the ips of the subdomains found.
- Enumerated the server headers by checking the response headers for each subdomain found.
- To Detect the Technologies used on the website used the python library `WebTech`.
- Used the `json` library to save all these results in a `json` file so it can be easily accessed and analysed further.

## Requirements
The following pip packages needs to be installed `WebTech` and the following tools need to installed `httpx`,`findomain`,`subfinder`, `Assetfinder` and `Amass`

## Installation & Usage
#### Clone the repository
#### chmod +x script.sh
#### chmod +x helper.sh
#### ./script.sh domain.com
