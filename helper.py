import os
import requests
import socket
import json
import argparse
import webtech


parser = argparse.ArgumentParser()
parser.add_argument("-f","--file", help="Input file of subdomains you've found")
args = parser.parse_args()


#Get ip address via socket.gethostbyname()
def get_ip_dns(url):
    url = url.split('://')[1]
    try:
        ip = socket.gethostbyname(url)
        return ip
    except socket.gaierror:
        return None


# Get Ip address via ip-api.com
def get_ip_api(url):
    url = url.split('://')[1]
    api_url = f"http://ip-api.com/json/{url}"
    try:
        response = requests.get(api_url)
        data = response.json()
        if data["status"] == "success":
            return data["query"]
        else:
            return None
    except requests.exceptions.RequestException:
        return None


#Get server head responses
def get_server_header(url):
    try:
        response = requests.get(url)
        server_header = response.headers.get('Server', 'Unknown')
        return server_header

    except requests.exceptions.RequestException:
        return None


#Detech Technologies using WebTech
def detect_technologies(url):
    wt = webtech.WebTech(options={'json': True})
    try:
        report = wt.start_from_url(url)
        return report
    except webtech.utils.ConnectionException:
        return None
    except Exception as e:
        return None


input_file = args.file
gathered_data = []


with open(input_file, "r") as infile:
    for line in infile:
        url = line.strip()
        ip = []
        ip_dns = get_ip_dns(url)
        ip_api = get_ip_api(url)
        if ip_api:
            ip.append(ip_api)
        if ip_dns != ip_api:
            ip.append(ip_dns)
        else:
            if ip_api == "" : ip = []


        technologies = detect_technologies(url)
        server_header = get_server_header(url)

        website_data = {
            "website": url,
            "Ip Address": ip,
            "server_header": server_header,
            "technologies": technologies
        }
        gathered_data.append(website_data)


#Write output to json file
with open('website_data.json', 'w') as json_file:
    json.dump(gathered_data, json_file, indent=4)