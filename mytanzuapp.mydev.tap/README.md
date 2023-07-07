# mytanzuapp.mydev.tap

* Workload type: Server
* Building from source (source to url)
    * Source: https://github.com/izabelacg/application-accelerator-samples
* Package Supply Chain
    * carvel-package-workflow: TRUE
        * Gitops repository: https://github.com/izabelacg/tap-gitops

## Deploy the workload

```sh
export WORKLOAD_NAMESPACE=mydev

kubectl apply -n $WORKLOAD_NAMESPACE -f tanzu-java-web-app-img-server.mydev.tap/gitops-secret.yaml

# server / source to url / package supply chain
tanzu apps workload create mytanzuapp \
--app mytanzuapp \
--git-repo https://github.com/izabelacg/application-accelerator-samples \
--sub-path tanzu-java-web-app \
--git-branch main \
--type server \
--label apps.tanzu.vmware.com/carvel-package-workflow=true \
--param "gitops_ssh_secret=git-ssh" \
--namespace $WORKLOAD_NAMESPACE

```

## Modify the workload

```sh

tanzu apps workload apply mytanzuapp \
--label app.kubernetes.io/part-of=mytanzuapp \
--namespace $WORKLOAD_NAMESPACE

```
