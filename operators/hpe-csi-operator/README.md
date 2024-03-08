# Operator SDK build and delivery process

This README describes how to build an Operator from the HPE CSI Driver Helm chart hosted in this repository.

Tutorial to get started with Operator Helm charts: https://sdk.operatorframework.io/docs/building-operators/helm/tutorial/

The workflow breaks down to this flowchart once you have two clusters installed and OLM running in the Vanilla cluster.

```
|-------------------------------------| 
| export KUBECONFIG=my-vanilla.yaml   |  |-----------------|
| export VERSION=2.4.2                |  | make deploy     |  |----------------|
| export REPO_NAME=quay.io/hpestorage |->| # Perform tests |->| make community |
| make build                          |  | make scorecard  |  |-------o--------|
|------------------------------------ |  |-----------------|          |
                                                                      |
                 o----------------------------------------------------o
                 |
|----------------V--------------|  |-----------------|  |----------------|
| export KUBECONFIG=my-ocp.yaml |->| make deploy     |->| make certified |
|-------------------------------|  | # Perform tests |  |--------o-------|
                                   |-----------------|           |
                                                                 |
            o----------------------------------------------------o
            |
|-----------V----------|  |---------|
| Submit Pull Request: |->| Reviews |
| - co-deployments     |  |--o---o--|
|----------------------|     |   |   |-----------------------|
                             |   o-->| Red Hat Certification |
            o----------------o       |-----------o-----------|
            |                                    |
|-----------V------------|           |-----------V-----------|
| Submit Pull Request    |           | Submit Pull Request   |
| - community-operators  |           | - certified-operators |
|------------------------|           |-----------------------|
```

## Testing and building for OLM

Install the `operator-sdk` binary on your computer, `docker`, `docker-buildx`, `make` and `sed` is also needed.

On you cluster, install OLM (ensure your KUBECONFIG points to a cluster).

```
operator-sdk olm install
```

Next, figure out what destination repositories you want to use. For example, I use `quay.io/datamattsson/csi-driver-operator` and `quay.io/datamattsson/csi-driver-operator-bundle`

```
export REPO_NAME=quay.io/datamattsson
```

Next, what version are we iterating on? Make sure to follow Semantic Versioning.

```
export VERSION=0.0.0
```

If you're making changes to update the Operators. Patrol all the files in `sources` and update decorations as necessary.

Next, build the Operator.

```
make build
```

If there are no errors, go ahead and deploy the Operator on your test cluster.

```
make deploy
```

You should be able to see the Operator come to life including a fresh install of the HPE CSI Driver.

```
kubectl get pods -A -w
```

Iterate this until it looks OK to submit. For good measure, generate the scorecard and make sure all tests pass.

```
make scorecard
```

Create the bundle for community-operators.

```
make community
```

## Testing and Building for OpenShift

Follow the same workflow as above, pointing to Red Hat's registry instead of Quay.

OpenShift does not require OLM pre-installed. Simply point to your OpenShift cluster run:

```
make build
make deploy
make scorecard
```

Once it looks good, build the output.

```
make certified
```

## Submitting a PR

In `destinations` are the current shipping versions of the Operator. Those needs to be updated with the new version and included in the PR. Make sure the same environment variables are set from the testing phases when making the community and certified targets.

A `git diff` should reveal all the work for the PR. Once PRs are approved in `co-deployments` and thoroughly tested, each bundle can be submitted to each upstream.

**Note:** The CSV for community-operators changes the name for each release, ensure the new CSV is included in the PR along with the CR sample for the version being submitted.

## External Testing

For testing and experimentation only the `operator-sdk` binary is required besides the cluster access with `kubectl` or `oc`.

In a typical test scenario, these are the steps for each of the supported platforms on a blank cluster.

Vanilla Kubernetes:

```
export VERSION=2.4.1
operator-sdk install olm
kubectl create ns hpe-storage
operator-sdk run bundle -n hpe-storage quay.io/hpestorage/csi-driver-operator-bundle:v${VERSION}
kubectl apply -n hpe-storage -f https://raw.githubusercontent.com/hpe-storage/co-deployments/master/operators/hpe-csi-operator/destinations/hpecsidriver-v${VERSION}-sample.yaml
```

OpenShift:

```
export VERSION=2.4.1
oc create ns hpe-storage
oc apply -f https://scod.hpedev.io/partners/redhat_openshift/examples/scc/hpe-csi-scc.yaml
operator-sdk run bundle -n hpe-storage quay.io/hpestorage/csi-driver-operator-bundle:v${VERSION}
kubectl apply -n hpe-storage -f https://raw.githubusercontent.com/hpe-storage/co-deployments/master/operators/hpe-csi-operator/destinations/hpecsidriver-v${VERSION}-sample.yaml
```

To cleanup or re-deploy (both Kubernetes and OpenShift):

```
operator-sdk cleanup hpe-csi-operator -n hpe-storage
```
