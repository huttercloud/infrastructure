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

### plex

mac mini running plex media server, serving the media from the synology nas.

- hostname: plex.hutter.cloud
- ip address: 192.168.30.27 (static lease in mikrotik)
- username: plex

the plex user is the auto logged in console user, which is what lets the
github actions runner launch agent keep a session.

## ansible

ansible is used to configure and upgrade the different physical nodes.

to run ansible the nucs must be manually installed, ssh and sudo need to be setup.
- add public ssh key to the system `ssh-copy-id -i .ssh/id_rsa.home node@192.168.30.61`
- allow node user full sudo rights without password (for ansible) `sudo /bin/sh -c "echo 'node ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/node"`

Afterwards the ansible playbooks for the nodes can be executed

```bash
make ansible-node-a
make ansible-node-b
make ansible-plex

# to upgrade all systems run
make ansible-upgrade-systems
```

## github self hosted runners

node-b and plex run self hosted github actions runners for the `circleup-ai`
organization, installed by the `github-runner` ansible role.

| node | label | runs as | installed in |
| --- | --- | --- | --- |
| node-b | `self-hosted-linux` | `github-runner` (systemd) | `/opt/actions-runner` |
| plex | `self-hosted-mac` | `plex` (launchd agent) | `/Users/plex/actions-runner` |

registration tokens expire an hour after github creates them, so the token in
1password is stale most of the time. that only matters when a runner is
registered for the first time - afterwards the role skips registration and the
token is never read. to add or re-register a runner:

- open the organization runner settings, *new runner*, and copy the `--token`
  value out of the instructions
- update `op://circleup/circleup Github Organization Self Hosted Runner Token/password`
- rerun the playbook within the hour, e.g.
  `cd ansible; op run --env-file="./environment" -- ../venv/bin/ansible-playbook -i inventory.ini playbook/node-b.yaml -t github-runner`

see `ansible/roles/github-runner/README.md` for the role variables and for how
runner upgrades are handled.
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
