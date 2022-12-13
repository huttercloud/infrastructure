# ansible

playbooks to manage the physical nodes

## usage 

```bash
source ../venv/bin/activate
op run --env-file="./environment" -- ansible-playbook -i inventory.ini playbook/node-a.yaml
```