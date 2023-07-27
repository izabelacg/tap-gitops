# ourtanzuapp.mydev.tap

* Workload type: Server
* Using existing image (image to url)
* Package Supply Chain
    * carvel-package-workflow: TRUE
        * Gitops repository: https://github.com/izabelacg/tap-gitops

Goal:

Test [Configure the OOTB Templates with custom Carvel Package parameters](https://docs-staging.vmware.com/en/draft/VMware-Tanzu-Application-Platform/1.6/tap/scc-carvel-package-supply-chain.html).

## Deploy the workload

```sh
export WORKLOAD_NAMESPACE=mydev

kubectl apply -n $WORKLOAD_NAMESPACE -f tanzu-java-web-app-img-server.mydev.tap/gitops-secret.yaml

# server / image to url / package supplychain
tanzu apps workload create ourtanzuapp \
--app ourtanzuapp \
--type server \
--label apps.tanzu.vmware.com/carvel-package-workflow=true \
--image us.gcr.io/daisy-284300/icg-vmware/build-service/workloads/mytanzuapp-mydev@sha256:d890d67d2d710423d458658637cab17ba7a2883e40077f0e964b2d0d3bb1289c \
--namespace $WORKLOAD_NAMESPACE
```

## Deploy a Carvel App

To deploy a Carvel app with the generated package and package installs to a TAP full profile cluster:

```sh
export WORKLOAD_NAMESPACE=mydev

kubectl apply -n $WORKLOAD_NAMESPACE -f tanzu-java-web-app-img-server.mydev.tap/gitops-secret.yaml

kubectl apply -n $WORKLOAD_NAMESPACE -f tanzu-java-web-app-img-server.mydev.tap/rbac.yaml
kubectl apply -n $WORKLOAD_NAMESPACE -f ourtanzuapp.mydev.tap/carvel-app.yaml

```

Testing the workload:

```shell
kubectl port-forward --namespace $WORKLOAD_NAMESPACE service/ourtanzuapp 8080:8080

export EXTERNAL_ADDRESS=$(kubectl get svc/envoy -n tanzu-system-ingress -ojsonpath="{.status.loadBalancer.ingress[0].ip}")
echo $EXTERNAL_ADDRESS

curl -H "Host: hello.$WORKLOAD_NAMESPACE.alm.bela.tanzu.biz" $EXTERNAL_ADDRESS
```

TAP VALUES file included the below snippets:

```shell
profile: full
ceip_policy_disclosed: true

shared:
  ingress_domain: famintos.tanzu.biz
  image_registry:
    project_path: "us.gcr.io/daisy-284300/icg-vmware/build-service"
    username: _json_key
    password: --redacted--
  
supply_chain: basic

ootb_supply_chain_basic:
  gitops:
    ssh_secret: "git-ssh"
    server_address: https://github.com/
    repository_owner: izabelacg
    repository_name: tap-gitops
  carvel_package:
    workflow_enabled: true
#    openapiv3_enabled: true

ootb_templates:
  carvel_package:
    parameters:
      - selector:
          matchLabels:
            apps.tanzu.vmware.com/workload-type: server
        schema: |
          #@data/values-schema
          ---
          #@schema/title "Workload name"
          #@schema/desc "Required. Name of the workload, used by K8s Ingress HTTP rules."
          #@schema/example "tanzu-java-web-app"
          #@schema/validation min_len=1
          workload_name: ""
  
          #@schema/title "Replicas"
          #@schema/desc "Number of replicas."
          replicas: 1
  
          #@schema/title "Port"
          #@schema/desc "Port number for the backend associated with K8s Ingress."
          port: 8080
  
          #@schema/title "Hostname"
          #@schema/desc "If set, K8s Ingress will be created with HTTP rules for hostname."
          #@schema/example "app.tanzu.vmware.com"
          hostname: ""
  
          #@schema/title "Cluster Issuer"
          #@schema/desc "CertManager Issuer to use to generate certificate for K8s Ingress."
          cluster_issuer: "tap-ingress-selfsigned"
          
          #@schema/title "Greeting message"
          #@schema/desc "Greeting message for tanzu-java-web-app."
          greeting: "all of you in Tanzu"
        overlays: |
          #@ load("@ytt:overlay", "overlay")
          #@ load("@ytt:data", "data")
          #@overlay/match by=overlay.subset({"apiVersion":"apps/v1", "kind": "Deployment"})
          ---
          spec:
            template:
              spec:
                containers:
                  #@overlay/match by=overlay.all, expects="1+"
                  -
                    #@overlay/match missing_ok=True
                    env:
                      - name: greeting
                        value: #@ data.values.greeting
tap_gui:
  service_type: ClusterIP 

metadata_store:
  app_service_type: ClusterIP

namespace_provisioner:
  controller: true
  namespace_selector:
    matchExpressions:
    - key: apps.tanzu.vmware.com/tap-ns
      operator: Exists
  default_parameters:
    supply_chain_service_account:
      secrets:
        - git-ssh
```
