#!/bin/python
import poplib
import os

os.system('echo -1 > /tmp/fetch_mail_count')
M = None
try:
    M = poplib.POP3_SSL(host='[hostname]', port=[port])
    M.user('[username]')
    M.pass_('[password]')
except Exception as e:
    os.system('echo -2 > /tmp/fetch_mail_count')
    os.system('echo "{0}" >> /tmp/fetch_mail_count'.format(e))
else:
    os.system('echo {0} > /tmp/fetch_mail_count'.format(M.stat()[0]))
if M:
    M.close()
