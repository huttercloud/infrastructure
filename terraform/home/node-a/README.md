# node-a

bootstrap resources running on node-a. node-a runs pihole and argocd

As these are base services everything else depends terraform is used
to bootstrap them

## argo-cd

The argo-cd manifest is generated with [tfk8s](https://github.com/jrhouston/tfk8s).

```bash
curl https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/install.yaml | tfk8s > argo-cd.tf
```

As the argo cd manifest depends on an existing namespace we need to create the namespace first

```bash
op run --env-file="../../../environment" -- terraform apply -target="kubernetes_namespace.argo_cd_namespace"
```