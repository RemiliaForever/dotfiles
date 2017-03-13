#!/bin/python
import poplib
import os

os.system('echo -1 > /tmp/fetch_mail_count')
M = None
mask = ''
count = 0
try:
    M = poplib.POP3_SSL(host='[hostname]', port=[port])
    M.user('[username]')
    M.pass_('[password]')
    count = count + M.stat()[0]
    if M.stat()[0] > 0:
        mask = '[[hostname]]'
    M = poplib.POP3_SSL(host='[hostname]')
    M.user('[username]@[hostname]')
    M.pass_('[password]')
    count = count + M.stat()[0]
    if M.stat()[0] > 0:
        if mask == '':
            mask = '[[hostname]]'
        else:
            mask = mask + ' [[hostname]]'

except Exception as e:
    os.system('echo -2 > /tmp/fetch_mail_count')
    os.system(f'echo "{e}" >> /tmp/fetch_mail_count')
else:
    os.system(f'echo "{count}\n{mask}" > /tmp/fetch_mail_count')
if M:
    M.close()
