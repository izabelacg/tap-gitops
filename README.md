# tap-gitops

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