# hutter.cloud infrastructure

## nodes

### node-a

intel nuc running Docker containers, providing pi-hole (dns), traefik (reverse proxy) and home assistant.
in addition, the node runs daily borgmatic backups for synology shares

- hostname: node-a.hutter.cloud
- ip address: 192.168.30.61 (static lease in mikrotik)
- username: node

### node-b

desktop pc, services are accessible from the internet.
runs Docker containers via Docker Compose (managed by Ansible roles).
services include: usenet stack (sabnzbd, sonarr, radarr, bazarr, nzbhydra2, prowlarr),
calibre, freshrss, overseerr, tautulli, pureftpd, and oauth2-proxy for authentication.

- hostname: node-b.hutter.cloud
- ip address: 192.168.30.90 (static lease in mikrotik)
- username: node

#### additional mikrotik config

```bash
# enable http/s port forwarding
/ip firewall nat add chain=dstnat action=dst-nat to-addresses=192.168.30.90 to-ports=80 protocol=tcp in-interface=bridge-vlan200 dst-port=80
/ip firewall nat add chain=dstnat action=dst-nat to-addresses=192.168.30.90 to-ports=443 protocol=tcp in-interface=bridge-vlan200 dst-port=443
```

## ansible

ansible is used to configure and upgrade the different physical nodes.

to run ansible the nucs must be manually installed, ssh and sudo need to be setup.
- add public ssh key to the system `ssh-copy-id -i .ssh/id_rsa.home node@192.168.30.61`
- allow node user full sudo rights without password (for ansible) `sudo /bin/sh -c "echo 'node ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/node"`

Afterwards the ansible playbooks for the nodes can be executed

```bash
make ansible-node-a
make ansible-node-b

# to upgrade all systems run
make ansible-upgrade-systems
```
## terraform

terraform is used to configure services like auth0, aws (route53, iam, ssm), mikrotik and pi-hole.

- remote state is stored in terraform cloud (run `terraform login`)
- credentials for the different environments are stored in 1password.
- the credentials are stored in each terraform resource in the corresponding environment file

## terraform resource order

the terraform resources are dependent on each other, the correct order for a full plan / apply cycle is:
- resources/auth0
- resources/aws/root/global
- resources/aws/root/eu-central-1
- resources/home/mikrotik

### running terraform

Use the make targets to execute tf for the different resources

```bash
make terraform-%
```

# borgmatic

If a new borgbase repo is added:
- add the borgbase configuration to the node from which to execute the backup
- run the ansible playbook with `-t borgbase`
- connect to the node via ssh
- initialize the borgbase repository (as root): `borgmatic-<job name>.sh init -e repokey-blake2`
- execute the initial backup (as root): `borgmatic-<job name>.sh create --verbosity 1 --list --stats`
