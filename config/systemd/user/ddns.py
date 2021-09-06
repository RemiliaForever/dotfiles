#!/bin/env python3

import requests

BASE_URL = 'https://api.dynu.com/v2'
ID = ''
HEADER = {'API-Key': ''}
PROXY = {'http': 'http://localhost:8118', 'https': 'http://localhost:8118'}

s = requests.Session()

print('====> query ip')
ip = s.get('https://api.ipify.org',
           headers={
               'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:73.0) Gecko/20100101 Firefox/73.0'
           }).content.decode('utf-8')
print(f'====> ip is [{ip}]')
print('====> upload ip')
r = s.post(f'{BASE_URL}/dns/{ID}',
           headers=HEADER,
           proxies=PROXY,
           json={
               'name': '',
               'ipv4Address': ip,
               'ttl': 300,
               'ipv4WildcardAlias': True,
           }).json()
print(f'====> response is [{r}]')
