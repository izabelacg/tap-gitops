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

## Deploy the Carvel App

To deploy a Carvel app with the generated package and manually created package install to a TAP full profile cluster:

```sh
export WORKLOAD_NAMESPACE=mydev
kubectl apply -n $WORKLOAD_NAMESPACE -f tanzu-java-web-app-img-server.mydev.tap/rbac.yaml
kubectl apply -n $WORKLOAD_NAMESPACE -f mytanzuapp.mydev.tap/carvel-app.yaml

```

Verify your app is running:
```sh
kubectl -n test exec -it deploy/flagger-loadtester bash
curl http://mytanzuapp.mydev:8080
#OR
kubectl port-forward --namespace mydev service/mytanzuapp 8080:8080
curl http://localhost:8080
```

## Modify the workload

```sh

tanzu apps workload apply mytanzuapp \
--label app.kubernetes.io/name=mytanzuapp \
--namespace $WORKLOAD_NAMESPACE

```

Verify that:

- app is running
- new package version was created in the gitops repo
- new app deployed and running has the new label

## Create and apply canary resource and httpproxy

```sh
kubectl apply -n $WORKLOAD_NAMESPACE -f mytanzuapp.mydev.tap/canary/mytanzuapp-canary.yaml
kubectl get canary/mytanzuapp -n $WORKLOAD_NAMESPACE
kubectl describe canary/mytanzuapp -n $WORKLOAD_NAMESPACE

kubectl apply -n $WORKLOAD_NAMESPACE -f mytanzuapp.mydev.tap/canary/mytanzuapp-ingress.yaml
kubectl get httpproxy -n $WORKLOAD_NAMESPACE

curl mytanzuapp.famintos.tanzu.biz
```

## Modify source code and watch progressive delivery to happen automatically