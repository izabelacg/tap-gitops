# tap-gitops

## Server workload using Package SupplyChain

### tanzu-java-web-app-img-server.mydev.tap

To deploy the server workload:

```sh
export WORKLOAD_NAMESPACE=mydev

kubectl apply -n $WORKLOAD_NAMESPACE -f tanzu-java-web-app-img-server.mydev.tap/gitops-secret.yaml

# server / image to url / package supplychain
tanzu apps workload create tanzu-java-web-app-img-server \
--app tanzu-java-web-app-img-server \
--type server \
--label apps.tanzu.vmware.com/carvel-package-workflow=true \
--image springcommunity/spring-framework-petclinic \
--param "gitops_ssh_secret=git-ssh" \
--namespace $WORKLOAD_NAMESPACE
```

To deploy the app to a TAP full profile cluster:

```sh
export WORKLOAD_NAMESPACE=mydev
kubectl apply -n $WORKLOAD_NAMESPACE -f tanzu-java-web-app-img-server.mydev.tap/rbac.yaml
kubectl apply -n $WORKLOAD_NAMESPACE -f tanzu-java-web-app-img-server.mydev.tap/app.yaml

```

Helpful commands: 

```sh
export PACKAGE_NAME=$(yq -e '.spec.refName' tanzu-java-web-app-img-server.mydev.tap/packages/20230626183112.0.0.yml)
export PACKAGE_VERSION=$(yq -e '.spec.version' tanzu-java-web-app-img-server.mydev.tap/packages/20230626183112.0.0.yml)

```