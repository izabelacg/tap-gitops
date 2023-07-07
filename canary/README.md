# Canary deployment

## Using Flagger

https://docs.flagger.app/tutorials/contour-progressive-delivery

```sh
export CONTOUR_NAMESPACE=tanzu-system-ingress
helm repo add flagger https://flagger.app

helm upgrade -i flagger flagger/flagger \
--namespace $CONTOUR_NAMESPACE \
--set meshProvider=contour \
--set ingressClass=contour \
--set prometheus.install=true

```

Test deployment:

```sh
kubectl create ns test

# https://github.com/fluxcd/flagger/tree/main/kustomize/tester
kubectl apply -k https://github.com/fluxcd/flagger//kustomize/tester?ref=main

# https://github.com/fluxcd/flagger/blob/main/kustomize/podinfo/deployment.yaml
kubectl apply -k https://github.com/fluxcd/flagger//kustomize/podinfo?ref=main

kubectl apply -f flagger/podinfo-canary.yaml
kubectl apply -f flagger/podinfo-ingress.yaml
```

TAP workload/deployment:

```sh
# server / source to url
tanzu apps workload apply tanzu-java-web-app \
--git-repo https://github.com/izabelacg/application-accelerator-samples \
--sub-path tanzu-java-web-app \
--git-branch main \
--type server \
--label app.kubernetes.io/part-of=tanzu-java-web-app \
--label app.kubernetes.io/name=tanzu-java-web-app \
--namespace $WORKLOAD_NAMESPACE

#OR
kubectl apply -n $WORKLOAD_NAMESPACE -f flagger/workload-tanzu-java-web-app.yaml

tanzu apps workload get tanzu-java-web-app --namespace $WORKLOAD_NAMESPACE
tanzu apps workload tail tanzu-java-web-app --namespace $WORKLOAD_NAMESPACE --timestamp --since 1h

#http://tanzu-java-web-app.famintos.tanzu.biz/actuator/health

kubectl apply -n $WORKLOAD_NAMESPACE -f flagger/tanzu-java-web-app-canary.yaml
kubectl get canary/tanzu-java-web-app -n $WORKLOAD_NAMESPACE
kubectl describe canary/tanzu-java-web-app -n $WORKLOAD_NAMESPACE

kubectl apply -n $WORKLOAD_NAMESPACE -f flagger/tanzu-java-web-app-ingress.yaml
kubectl get httpproxy -n $WORKLOAD_NAMESPACE
```

Helpful commands: 

```sh
export ADDRESS="$(kubectl -n $CONTOUR_NAMESPACE get svc/envoy -ojson \
| jq -r ".status.loadBalancer.ingress[].ip")"
echo $ADDRESS

```

References:

* https://docs.flagger.app/faq#how-to-retry-a-failed-release

Notes:

- replaces original pod with primary created by flagger
  - could it be a problem when deploying a pkg/pkgi since kapp reconcile changes?
- deleting canary resource deleted the original pod and everything related
  - gets recreated eventually > 12min
