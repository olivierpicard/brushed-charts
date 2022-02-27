to expose a pod port, use a service.
The service selector must match the lab of the pod you want to expose
The nodePort of the 

Thing to do with kubernetes:
    - enable dns and registry on microk8s
    - in dev environnement configure docker deamon JSON to allow insecure localhost:32000 (microk8s) and to enabele buildKit
    - configure docker to use gcp registry by installing gcloud 
```shell
    ./google-cloud-sdk/install.sh --usage-reporting false --command-completion true --path-update true -q
```
    - Use the service account 'docker-configurator' and login using gcloud (in the future replace this by federate workload.
```shell 
     gcloud auth configure-docker eu.gcr.io
```
    - to mount secrets and etc data in the same directory use projected volume. the name field match the filename that will be created

Things Tryed but not worked:
- to build a secret use kustomisation file secret generator with file /etc/brushed-charts/...gcp-jsonkey. This methode don't work because the file specified is not in the same (or bellow) directory of kustomization.yaml