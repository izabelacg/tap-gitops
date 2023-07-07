# tap-gitops

## mytanzuapp.mydev.tap

Go to [README.md](mytanzuapp.mydev.tap/README.md).

## tanzu-java-web-app-img-server.mydev.tap

Go to [README.md](tanzu-java-web-app-img-server.mydev.tap/README.md).

## Canary deployment

Go to [README.md](canary/README.md).

Canary deployment instructions of the example described in the guide [Contour Canary Deployments](https://docs.flagger.app/tutorials/contour-progressive-delivery)
and also, of the workload below:

* Workload type: Server
* Building from source (source to url)
  * Source: https://github.com/izabelacg/application-accelerator-samples
* Package Supply Chain
  * carvel-package-workflow: FALSE

## Config folder

Configuration of apps created using Package Supply Chain.

### myapp.mydev

* Workload type: Web
* Building from source (source to url)
  * Source: https://github.com/vmware-tanzu/application-accelerator-samples
* Package Supply Chain
  * carvel-package-workflow: FALSE

### myserverapp.mydev

* Workload type: Server
* Building from source (source to url)
  * Source: https://github.com/vmware-tanzu/application-accelerator-samples
* Package Supply Chain
  * carvel-package-workflow: FALSE

Command:

```shell
# server / source to url
tanzu apps workload create myserverapp \
--git-repo https://github.com/vmware-tanzu/application-accelerator-samples \
--sub-path tanzu-java-web-app \
--git-branch main \
--type server \
--label app.kubernetes.io/part-of=tanzu-java-web-app \
--namespace $WORKLOAD_NAMESPACE
```

Reference: https://gitlab.eng.vmware.com/igomes/verbose-couscous

### tanzu-java-web-app.mydev

* Workload type: Server
* Building from source (source to url)
  * Source: https://github.com/izabelacg/application-accelerator-samples
* Package Supply Chain
  * carvel-package-workflow: FALSE

**Note**: This is the workload used in the canary deployment experiment 1. See [this README.md](canary/README.md).