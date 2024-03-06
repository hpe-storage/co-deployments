# Operator SDK build and delivery process

This README describes how to build an Operator from the HPE CSI Driver Helm chart host in this repository.

Source to get started with Operator Helm charts: https://sdk.operatorframework.io/docs/building-operators/helm/tutorial/

The workflow breaks down to this workflow once you have two clusters installed and OLM running in the Vanilla cluster.

```
|-------------------------------------| 
| export KUBECONFIG=my-vanilla.yaml   |  |-----------------|
| export VERSION=2.4.2                |  | make deploy     |  |----------------|
| export REPO_NAME=quay.io/hpestorage |->| # Perform tests |->| make community |
| make build                          |  |-----------------|  |-------o--------|
|-------------------------------------|                               |
                 o----------------------------------------------------o
                 |
|----------------V----------------------------------------| 
| export KUBECONFIG=my-ocp.yaml                           |  |-----------------|
| export VERSION=2.4.2                                    |  | make deploy     |  
| export REPO_NAME=registry.connect.redhat.com/hpestorage |->| # Perform tests |
| make build                                              |  |--------o--------|  
|---------------------------------------------------------|           |
                                                             |--------V--------|
                                                             | make certified  |
                                                             |--------o--------|
                                                                      |       
                                                      |---------------V--------|
                                                      | Submit Pull Requests:  |
                                                      | - co-deployments       |
                                                      | - certified-operators  |
                                                      | - community-operators  |
                                                      |------------------------|

```

## Testing and building for OLM

**Caution:** This workflow most like only work on Mac.

Install the `operator sdk` on your computer, `make` and `sed` is also needed.

On you cluster, install OLM (ensure your KUBECONFIG points to a cluster).

```
operator-sdk olm install
```

Next, figure out what destination repositories you want to use. For example, I use `quay.io/datamattsson/csi-driver-operator` and `quay.io/datamattsson/csi-driver-operator/bundle`

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

Iterate this until it looks OK to submit.

```
make community
```

## Testing and Building for OpenShift

Follow the same workflow as above, pointing to Red Hat's registry instead of Quay.

OpenShift does not require OLM pre-installed. Simply point to your OpenShift cluster and `make deploy`.

Once it looks good, build the output.

```
make certified
```

## Submitting a PR

In `destinations` are the current shipping versions of the Operator. Those needs to be updated with the new version and included in the PR. Make sure the same environment variables are set from the Testing phase.

A `git diff` should reveal all the work for the PR. Once PRs are approved in `co-deployments` and thoroughly tested, each bundle can be submitted to each upstream.
