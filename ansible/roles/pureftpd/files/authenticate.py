#!/usr/bin/env python3

"""
    use auth0 client to verify user credentials
"""

import requests
import traceback
import syslog
import os
from email_validator import validate_email

# auth0 config, passed as env vars to pod
AUTH0_DOMAIN = os.getenv('AUTH0_DOMAIN')
AUTH0_CLIENT_ID = os.getenv('AUTH0_CLIENT_ID')
AUTH0_CLIENT_SECRET = os.getenv('AUTH0_CLIENT_SECRET')
AUTH0_AUDIENCE = os.getenv('AUTH0_AUDIENCE')
AUTH0_SCOPE = os.getenv('AUTH0_SCOPE')
AUTH0_DOMAIN = os.getenv('AUTH0_DOMAIN')

# pure-ftpd authd env vars
AUTHD_ACCOUNT = os.getenv('AUTHD_ACCOUNT')
AUTHD_PASSWORD = os.getenv('AUTHD_PASSWORD')

def send_syslog(message: str):
    """
        send log message to syslog
    """

    syslog.syslog(f'pure-ftpd extauth: {message}')

def return_auth(auth_state: int=1):
    """
        print the authentication result to stdout
    """

    print(f'''
auth_ok:{auth_state}'
uid:999
gid:999
dir:/ftp
end
    ''')

if __name__ == '__main__':

    try:
        send_syslog(message=f'authentication process for {AUTHD_ACCOUNT} started')

        validate_email(AUTHD_ACCOUNT, check_deliverability=False)

        auth_payload=dict(
            grant_type='http://auth0.com/oauth/grant-type/password-realm',
            realm='Username-Password-Authentication',
            client_id=AUTH0_CLIENT_ID,
            client_secret=AUTH0_CLIENT_SECRET,
            audience=AUTH0_AUDIENCE,
            username=AUTHD_ACCOUNT,
            password=AUTHD_PASSWORD,
            scope=AUTH0_SCOPE,
        )

        r = requests.post(
            url=f'https://{AUTH0_DOMAIN}/oauth/token',
            json=auth_payload
        )
        r.raise_for_status()
        return_auth()

    except Exception as ex:
        send_syslog(message=traceback.format_exc())
        return_auth(auth_state=-1)

    send_syslog('authentication process ended')
