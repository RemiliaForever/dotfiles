#!/bin/env python

import socket
import imaplib
import re


def parse_status(s: bytes):
    return int(re.search(r'UNSEEN\s+(\d+)', str(s)).group(1))


def write_file(s: str):
    f = open('/tmp/fetch_mail_count', 'w')
    f.write(s)
    f.close()


socket.setdefaulttimeout(10)

write_file('-1')
M = None
mask = ''
count = 0
try:
    M = imaplib.IMAP4_SSL('', '')
    M.login('', '')
    M.select(readonly=True)
    count_hostname = parse_status(M.status('INBOX', '(UNSEEN)'))
    M.close()
    if count_hostname > 0:
        mask = ''
    count += count_hostname

    M = imaplib.IMAP4_SSL('')
    M.login('', '')
    M.select(readonly=True)
    count_hostname = parse_status(M.status('INBOX', '(UNSEEN)'))
    count_hostname += parse_status(M.status('&UXZO1mWHTvZZOQ-/Confluence', '(UNSEEN)'))
    count_hostname += parse_status(M.status('&UXZO1mWHTvZZOQ-/JIRA', '(UNSEEN)'))
    count_hostname += parse_status(M.status('&UXZO1mWHTvZZOQ-/GitLab', '(UNSEEN)'))
    M.close()
    count += count_hostname
    if count_hostname > 0:
        if mask == '':
            mask = ''
        else:
            mask += ''
except Exception as e:
    print(e)
    write_file(f'-2\n {e}')
else:
    write_file(f'{count}\n{mask}')

if M is not None and M.state == 'SELECTED':
    M.close()
