# node-a

bootstrap resources running on node-a. node-a runs pihole and argocd

As these are base services everything else depends terraform is used
to bootstrap them

## first setup

the external secrets provider implements crds required for the clustersecretstore
even though depends_on is set for the store the terraform fails due to the crds being unknown.
so circumvent this the helm chart needs to be installed first.

```bash
op run --env-file="./environment" -- terraform apply -target helm_release.external_secrets
```