# tap-gitops

## tanzu-java-web-app-img-server.mydev.tap


```sh
export WORKLOAD_NAMESPACE=mydev
kubectl apply -n $WORKLOAD_NAMESPACE -f tanzu-java-web-app-img-server.mydev.tap/rbac.yaml
kubectl apply -n $WORKLOAD_NAMESPACE -f tanzu-java-web-app-img-server.mydev.tap/app.yaml

# export PACKAGE_NAME=$(yq -e '.spec.refName' tanzu-java-web-app-img-server.mydev.tap/packages/20230626183112.0.0.yml)
# export PACKAGE_VERSION=$(yq -e '.spec.version' tanzu-java-web-app-img-server.mydev.tap/packages/20230626183112.0.0.yml)


```