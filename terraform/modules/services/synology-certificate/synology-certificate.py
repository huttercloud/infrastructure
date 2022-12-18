#!/usr/bin/env python3

"""
    retrieve the certificate stored as a kubernetes secret (mnanaged by cert-manager)
    retrieve the certificate from nas.hutter.cloud
    compare timestamps and if close to expiry replace the certificate on the synology nas
"""

import paramiko
import scp
import socket
import ssl
import sys
from cryptography import x509
from cryptography.hazmat.primitives.serialization import Encoding, PublicFormat
import logging
from typing import Dict, Tuple
import re
import io


def get_certificate_from_synology(host: str = 'nas.hutter.cloud', port: int = 5001) -> x509.Certificate:
    """
        retrieve the certificate from the synology nas
        thanks to: https://stackoverflow.com/questions/71139519/python-how-to-get-expired-ssl-cert-date
    """
    context = ssl.create_default_context()
    context.check_hostname = False
    context.verify_mode = ssl.CERT_NONE

    with socket.create_connection((host, port)) as sock:
        with context.wrap_socket(sock, server_hostname=host) as ssock:
            data = ssock.getpeercert(True)
            pem_data = ssl.DER_cert_to_PEM_cert(data)
            return x509.load_pem_x509_certificate(pem_data.encode('UTF-8'))

def get_certificate_from_local_secret(certificate_file: str = '/certificate/tls.crt', key_file: str = '/certificate/tls.key') -> Tuple[Dict[str, x509.Certificate], str]:
    """
        get certificate from filesystem (mounted via k8s volume mount)
    """

    with open(certificate_file, 'r') as f:
        certificate_data = f.read()
    with open(key_file, 'r') as f:
        key_data = f.read()


    s = re.compile("(-----BEGIN CERTIFICATE-----[\w\W]*?-----END CERTIFICATE-----)")
    pem_certificates = s.findall(certificate_data)
    
    certificates = dict()
    certificates['cert'] = x509.load_pem_x509_certificate(pem_certificates[0].encode('UTF-8'))
    certificates['intermediate'] = x509.load_pem_x509_certificate(pem_certificates[1].encode('UTF-8'))
    certificates['root'] = x509.load_pem_x509_certificate(pem_certificates[2].encode('UTF-8'))

    return (certificates, key_data)

def upload_certificate_script_to_synology(certificates: Dict[str, x509.Certificate], private_key: str, host: str = 'nas.hutter.cloud', username: str = 'admin', ssh_key_file: str = '/ssh-key/private-key', script_path: str = '/tmp/synology-certificate.sh'):
    """
        render and upload a bash script to the synology nas
    """

    cert = certificates['cert'].public_bytes(encoding=Encoding.PEM).decode('UTF-8').strip()
    intermediate = certificates['intermediate'].public_bytes(encoding=Encoding.PEM).decode('UTF-8').strip()
    root = certificates['root'].public_bytes(encoding=Encoding.PEM).decode('UTF-8').strip()
    privkey = private_key.strip()


    bash_script = f'''
set -e

# copy certificate and key
echo copy privkey
cat << EOF > /usr/syno/etc/certificate/system/default/privkey.pem
{privkey}
EOF

echo copy cert
cat << EOF > /usr/syno/etc/certificate/system/default/cert.pem
{cert}
EOF

echo copy chain
cat << EOF > /usr/syno/etc/certificate/system/default/chain.pem
{intermediate}
{root}
EOF

echo copy fullchain
cat << EOF > /usr/syno/etc/certificate/system/default/fullchain.pem
{cert}
{intermediate}
{root}
EOF

# ensure proper permissions
echo set certificate permissions
chown root:root /usr/syno/etc/certificate/system/default/*.pem
chmod 0400 /usr/syno/etc/certificate/system/default/*.pem

# setup synology drive certificate
echo copy certs for synology drive
cp -a /usr/syno/etc/certificate/system/default/*.pem /usr/local/etc/certificate/SynologyDrive/SynologyDrive

# restart services
echo restart services
/usr/syno/sbin/synoservice --restart nginx
/usr/syno/sbin/synoservice --restart nmbd
/usr/syno/sbin/synoservice --restart avahi
/usr/syno/sbin/synoservice --restart ldap-server

# remove script
set +e
rm -- "${{0}}"
    '''

    # prepare file like object containing the rendered bash script
    bash_script_fo = io.BytesIO()
    bash_script_fo.write(bash_script.encode('UTF-8'))
    bash_script_fo.seek(0)

    # setup ssh connection
    ssh_private_key = paramiko.RSAKey.from_private_key_file(ssh_key_file)
    ssh_client = paramiko.SSHClient()
    ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh_client.connect(hostname=host, username=username, pkey=ssh_private_key)

    # upload file 
    scp_client = scp.SCPClient(ssh_client.get_transport())
    scp_client.putfo(bash_script_fo, script_path)

    # close all connections
    scp_client.close()
    bash_script_fo.close()
    ssh_client.close()

def execute_certificate_script_on_synology(host: str = 'nas.hutter.cloud', username: str = 'admin', ssh_key_file: str = '/ssh-key/private-key', script_path: str = '/tmp/synology-certificate.sh'): 
    """
        execute the given script on the system with root rights (passwordless sudo required)
    """

    ssh_private_key = paramiko.RSAKey.from_private_key_file(ssh_key_file)
    ssh_client = paramiko.SSHClient()
    ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh_client.connect(hostname=host, username=username, pkey=ssh_private_key)
    stdin, stdout, stderr = ssh_client.exec_command(f'sudo bash {script_path}')

    stdout_content = stdout.read()
    stderr_content = stderr.read()

    if stdout.channel.recv_exit_status() != 0:
        raise Exception(f'error in ssh command - stdout: {stdout_content.decode("UTF-8")}, stderr: {stderr_content.decode("UTF-8")}.')

    ssh_client.close()


if __name__ == '__main__':

    try:
        current_certificate = get_certificate_from_synology()
        new_certificates_and_key = get_certificate_from_local_secret()

        if current_certificate.not_valid_before == new_certificates_and_key[0]['cert'].not_valid_before:
            logging.info('Same certificate, nothin todo!')
            sys.exit(0)

        upload_certificate_script_to_synology(new_certificates_and_key[0], new_certificates_and_key[1])
        execute_certificate_script_on_synology()

    except Exception as e:
        logging.error(e)
        sys.exit(1)