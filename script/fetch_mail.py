#!/bin/python
import imaplib
import os
import re


def parse_status(s):
    return int(re.search('UNSEEN\s+(\d+)', str(s)).group(1))


os.system('echo -1 > /tmp/fetch_mail_count')
M = None
mask = ''
count = 0
try:
    M = imaplib.IMAP4_SSL('[hostname]', '[port]')
    M.login('[username]', '[password]')
    M.select(readonly=True)
    count_hostname = parse_status(M.status('INBOX', '(UNSEEN)'))
    M.close()
    if count_hostname > 0:
        mask = '[[hostname]]'
    count += count_hostname

    M = imaplib.IMAP4_SSL('[hostname]')
    M.login('[username]@[hostname]', '[password]')
    M.select(readonly=True)
    count_hostname = parse_status(M.status('INBOX', '(UNSEEN)'))
    M.close()
    count += count_hostname
    if count_hostname > 0:
        if mask == '':
            mask = '[[hostname]]'
        else:
            mask += ' [[hostname]]'

    M = False
except Exception as e:
    os.system('echo -2 > /tmp/fetch_mail_count')
    os.system(f'echo "{e}" >> /tmp/fetch_mail_count')
else:
    os.system(f'echo "{count}\n{mask}" > /tmp/fetch_mail_count')
if M:
    M.close()
