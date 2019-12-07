#!/bin/python3

import requests

BASE_URL = 'https://api.dynu.com/v2'
ID = '[id]'
HEADER = {'API-Key': '[key]'}
PROXY = {'http': 'http://localhost:8118', 'https': 'http://localhost:8118'}

s = requests.Session()

print(f'====> query ip')
ip = s.get('https://ip.cn', headers={'User-Agent': 'curl/7.65.3'}).json()['ip']
print(f'====> ip is [{ip}]')
print(f'====> upload ip')
r = s.post(f'{BASE_URL}/dns/{ID}',
           headers=HEADER,
           proxies=PROXY,
           json={
               'name': '[domain]',
               'ipv4Address': ip
           }).json()
print(f'====> response is [{r}]')
