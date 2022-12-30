# hutter.cloud infrastructure

## nodes

### node-a

intel nuc running kubernetes, providing pi-hole (dns), unifi controller and wireguard vpn.
in addition, the node runs daily borgmatic backups for synology shares

- hostname: node-a.hutter.cloud
- ip address: 192.168.30.61 (static lease in mikrotik)
- username: node

#### additional mikrotik config

```bash
# enable routing to wireguard network
/ip route add dst-address=192.168.130.0/24 gateway=192.168.30.253
# enable portforwarding from internet to wireguard
/ip firewall nat add chain=dstnat action=dst-nat to-addresses=192.168.30.61 to-ports=32767 protocol=udp in-interface=bridge-vlan200 dst-port=32767
```

### node-b

desktop pc, services are accessible from the internet.
runs kubernetes, argo cd and everything else.

- hostname: node-b.hutter.cloud
- ip address: 192.168.30.90 (static lease in mikrotik)
- username: node

#### additional mikrotik config

```bash
# enable http/s port forwardinf
/ip firewall nat add chain=dstnat action=dst-nat to-addresses=192.168.30.90 to-ports=80 protocol=tcp in-interface=bridge-vlan200 dst-port=80
/ip firewall nat add chain=dstnat action=dst-nat to-addresses=192.168.30.90 to-ports=443 protocol=tcp in-interface=bridge-vlan200 dst-port=443
```

### node-c

intel nuc used for ssh access and run docker and docker compose on amd64!
- hostname: node-c.hutter.cloud
- ip address: 192.168.30.21 (static lease in mikrotik)
- username: node

#### additional mikrotik config

none

## ansible 

ansible is used to configure to configure and upgrade the different physical nodes.

to run ansible the nucs must be manually installed, ssh and sudo need to be setup.
- add public ssh key to the system `ssh-copy-id -i .ssh/id_rsa.home node@192.168.30.61`
- allow node user full sudo rights without password (for ansible) `sudo /bin/sh -c "echo 'node ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/node"`

Afterwards the ansible playbooks for the nodes can be executed

```bash
make ansible-node-a
make ansible-node-b
make ansible-node-c

# to upgrade all systems run
make ansible-upgrade systems
```
## terraform

terraform is used to configure all services required for a running environment.
For the nodes this includes:

- pi-hole for dns
- wireguard for mgmt vpn
- unifi controller for wlan
- argocd for application management

- remote state is stored in terraform cloud (run `terraform login`)
- credentials for the different environments are stored in 1password.
- the credentials are stored in earch terraform resource in the corresponding environment file

## terraform resource order

the terraform resources are dependent on each other, the correct order for a full plan / apply cycle is:
- resources/auth0
- resources/grafana
- resources/aws/root/global
- resources/aws/root/eu-central-1
- resources/home/mikrotik
- resources/home/pi-hole
- resources/home/node-a
- resources/home/node-b

### first terraform run

terraform is used to deploy pods to kubernetes. These are dependent on CRDs. As long as the CRDs are not installed in the kubernetes cluster the terraform run will fail. To ensure the CRDs are installed before the first terraform execution needs
to be targeted:

```bash
# node a
cd terraform/resources/home/node-a
op run --env-file="./environment" -- terraform apply -target module.external_secrets

# node b
cd terraform/resources/home/node-a
op run --env-file="./environment" -- terraform apply -target module.external_secrets -target moduke.argo_cd
```

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
