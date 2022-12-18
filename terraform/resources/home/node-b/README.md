# node-b

bootstrap resources running on node-b. node-a runs external services

## first setup

the external secrets provider implements crds required for the clustersecretstore
even though depends_on is set for the store the terraform fails due to the crds being unknown.
so circumvent this the helm chart needs to be installed first.

```bash
op run --env-file="./environment" -- terraform apply -target module.external_secrets -target module.grafana_agent_operator
```