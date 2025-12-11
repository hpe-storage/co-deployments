# Operator SDK build and delivery process

This README describes how to build an Operator from the HPE CSI Driver Helm chart hosted in this repository.

Tutorial to get started with Operator Helm charts: https://sdk.operatorframework.io/docs/building-operators/helm/tutorial/

The workflow breaks down to this flowchart once you have two clusters installed and OLM running in the Vanilla cluster.

```
o-------------------------------------o
| export KUBECONFIG=vanilla.yaml      |  o--------------------------o
| export VERSION=2.4.2                |->| make community-deploy    |
| export REPO_NAME=quay.io/hpestorage |  | # Perform tests          |
| make community                      |  | make community-scorecard |
o-------------------------------------o  o------------v-------------o
                                                      |
                 o------------------------------------o
                 |
o----------------V-----------o  o--------------------------o
| export KUBECONFIG=ocp.yaml |->| make certified-deploy    |
| make certified             |  | # Perform tests          |
o----------------------------o  | make certified-scorecard |
                                o------------v-------------o
                                             | 
            o--------------------------------o
            |
o-----------V----------o  o---------o
| Submit Pull Request: |->| Reviews |
| - co-deployments     |  o--v---v--o
o----------------------o     |   |   o-----------------------o
                             |   o-->| Red Hat Certification |
            o----------------o       o-----------v-----------o
            |                                    |
o-----------V------------o           o-----------V-----------o
| Submit Pull Request    |           | Submit Pull Request   |
| - community-operators  |           | - certified-operators |
o------------------------o           o-----------------------o
```

## Testing and building for OLM

Install the `operator-sdk` binary on your computer, `docker`, `docker-buildx`, `make` and `sed` is also needed.

On you cluster, install OLM (ensure your KUBECONFIG points to a cluster).

```
operator-sdk olm install
```

Next, figure out what destination repositories you want to use. For example, I use `quay.io/datamattsson` as the base.

```
export REPO_NAME=quay.io/datamattsson
```

Next, what version are we iterating on? Make sure to follow Semantic Versioning.

```
# Do not include the initial 'v' used in image tags
export VERSION=0.0.0
```

If you're making changes to update the Operators. Patrol all the files in `sources` and update decorations as necessary.

Next, build the Operator.

```
make community
```

If there are no errors, go ahead and deploy the Operator on your test cluster.

```
make community-deploy
```

You should be able to see the Operator come to life including a fresh install of the HPE CSI Driver.

```
kubectl get pods -n hpe-storage -w
```

Iterate this until it looks OK to submit. For good measure, generate the scorecard and make sure all tests pass.

```
make community-scorecard
```

## Testing and Building for OpenShift

Follow the same workflow as above, pointing to Red Hat's registry instead of Quay.

OpenShift does not require OLM pre-installed. Simply point to your OpenShift cluster run:

```
make certified
make certified-deploy
make certified-scorecard
```

## Submitting a PR

In `destinations` are the current shipping versions of the Operator. Those needs to be updated with the new version and included in the PR. Make sure the same environment variables are set from the testing phases when making the community and certified targets.

A `git diff` should reveal all the work for the PR. Once PRs are approved in `co-deployments` and thoroughly tested, each bundle can be submitted to each upstream.

**Note:** The CSV for community-operators changes the name for each release, ensure the new CSV is included in the PR along with the CR sample for the version being submitted.

## External Testing

For testing and experimentation only, the `operator-sdk` binary is required besides the cluster access with `kubectl` or `oc`.

In a typical test scenario, these are the steps for each of the supported platforms on a blank cluster.

Common for Kubernetes and OpenShift:

```
export VERSION=2.5.1
export REPO=quay.io/hpestorage
export BRANCH=master
```

**Note:** For testing unreleased bundles sitting in a developers private registry, replace REPO with the private registry, i.e. `quay.io/datamattsson`. To pull the `HPECSIDriver` sample file from an unmerged PR, replace BRANCH with `refs/heads/<branch name>`

Vanilla Kubernetes:

```
operator-sdk olm install
kubectl create ns hpe-storage
operator-sdk run bundle -n hpe-storage ${REPO}/csi-driver-operator-bundle:v${VERSION}
kubectl apply -n hpe-storage -f https://raw.githubusercontent.com/hpe-storage/co-deployments/${BRANCH}/operators/hpe-csi-operator/destinations/hpecsidriver-v${VERSION}-sample.yaml
```

OpenShift:

```
oc create ns hpe-storage
oc apply -f https://scod.hpedev.io/csi_driver/partners/redhat_openshift/examples/scc/hpe-csi-scc.yaml
operator-sdk run bundle --security-context-config=restricted -n hpe-storage ${REPO}/csi-driver-operator-bundle-ocp:v${VERSION}
oc apply -n hpe-storage -f https://raw.githubusercontent.com/hpe-storage/co-deployments/${BRANCH}/operators/hpe-csi-operator/destinations/hpecsidriver-v${VERSION}-sample.yaml
```

To cleanup or re-deploy (both Kubernetes and OpenShift):

```
operator-sdk cleanup hpe-csi-operator -n hpe-storage
```
