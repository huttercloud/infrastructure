# hutter.cloud infrastructure

# terraform

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

# nodes

a node is installed with ubuntu 22.04 LTS server edition.
## configuration
1. setup virtualenv for ansible, ensure terraform 1.3 is installed
1. install ubuntu on nucs
2. install ubuntu server with `openssh`
3. add public ssh key to the system `ssh-copy-id -i .ssh/id_rsa.home node@192.168.30.61`
4. allow node user full sudo rights without password (for ansible) `sudo /bin/sh -c "echo 'node ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/node"`
- change password of user
5. run the corresponding ansible playbooks 
  - `cd ansible`
  - `op run --env-file="./environment" -- ansible-playbook -i inventory.ini playbook/node-a.yaml`
6. apply terraform code for node-a and node-b `cd terraform/home/node-a; 
  - `cd terraform/resources/home/node-a`
  - `op run --env-file="./environment" -- terraform apply -target module.external_secrets -target module.grafana_agent_operator`
  - `op run --env-file="./environment" -- terraform apply`


## using terraform with one password
```bash
# example execution for mikrotik
cd terraform/resources/home/mikrotik
op run --env-file="./environment" -- terraform apply
```

## node-a

one of the old nucs. this system will mainly serve pi-hole and handle http/s redirects
- hostname: node-a.hutter.cloud
- ip address: 192.168.30.61
- username: node

## node-b

tbd
# borgmatic

If a new borgbase repo is added:
- add the borgbase configuration to the node from which to execute the backup
- run the ansible playbook with `-t borgbase`
- connect to the node via ssh
- initialize the borgbase repository (as root): `borgmatic-<job name>.sh init -e repokey-blake2`
- execute the initial backup (as root): `borgmatic-<job name>.sh create --verbosity 1 --list --stats`