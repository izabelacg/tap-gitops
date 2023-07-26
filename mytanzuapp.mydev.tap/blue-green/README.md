# blue-green deployment (WIP - did not get to work yet)

## Create and apply canary resource

  ```sh
  kubectl apply -n $WORKLOAD_NAMESPACE -f mytanzuapp.mydev.tap/blue-green/mytanzuapp-blue-green.yaml
  kubectl get canary/mytanzuapp -n $WORKLOAD_NAMESPACE
  kubectl describe canary/mytanzuapp -n $WORKLOAD_NAMESPACE

  kubectl -n flagger logs deployment/flagger -f | jq .msg 
  ```

## Modify source code and watch the blue-green deployment happen