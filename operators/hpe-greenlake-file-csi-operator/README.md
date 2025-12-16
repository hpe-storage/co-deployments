# Operator SDK build and delivery process

This README describes how to build an Operator from the HPE GreenLake for File Storage CSI Driver Helm chart hosted in this repository.

Tutorial to get started with Operator Helm charts: https://sdk.operatorframework.io/docs/building-operators/helm/tutorial/

The workflow breaks down to this flowchart.

```
o-------------------------------------o
| export KUBECONFIG=ocp.yaml          |  o--------------------------o
| export VERSION=2.4.2                |->| make certified-deploy    |
| export REPO_NAME=quay.io/hpestorage |  | # Perform tests          |
| make certified                      |  | make certified-scorecard |
o-------------------------------------o  o------------v-------------o
                                             | 
            o--------------------------------o
            |
o-----------V----------o  o---------o
| Submit Pull Request: |->| Reviews |
| - co-deployments     |  o------v--o
o----------------------o         |   o-----------------------o
                                 o-->| Red Hat Certification |
                                     o-----------v-----------o
                                                 |
                                     o-----------V-----------o
                                     | Submit Pull Request   |
                                     | - certified-operators |
                                     o-----------------------o
```

## Testing and building for OpenShift

Install the `operator-sdk` binary on your computer, `docker`, `docker-buildx`, `oc`, `make` and `sed` is also needed.

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
make certified
```

If there are no errors, go ahead and deploy the Operator on your test cluster.

```
make certified-deploy
```

You should be able to see the Operator come to life including a fresh install of the HPE GreenLake for File Storage CSI Driver.

```
oc get pods -n hpe-storage -w
```

Iterate this until it looks OK to submit. For good measure, generate the scorecard and make sure all tests pass.

```
make certified-scorecard
```

## Submitting a PR

In `destinations` are the current shipping versions of the Operator. Those needs to be updated with the new version and included in the PR. Make sure the same environment variables are set from the testing phases when making the certified targets.

A `git diff` should reveal all the work for the PR. Once PRs are approved in `co-deployments` and thoroughly tested, each bundle can be submitted to upstream.

## External Testing

For testing and experimentation only, the `operator-sdk` binary is required besides the cluster access with `kubectl` or `oc`.

In a typical test scenario, these are the steps for each of the supported platforms on a blank cluster.

While connected to an OpenShift cluster:

```
export VERSION=1.0.0
export REPO=quay.io/hpestorage
export BRANCH=master
oc create ns hpe-storage
oc apply -f https://scod.hpedev.io/csi_driver/partners/redhat_openshift/examples/scc/hpe-filex-csi-scc.yaml
operator-sdk run bundle -n hpe-storage ${REPO}/filex-csi-driver-operator-bundle-ocp:v${VERSION}
oc apply -n hpe-storage -f https://raw.githubusercontent.com/hpe-storage/co-deployments/${BRANCH}/operators/hpe-greenlake-file-csi-operator/destinations/hpegreenlakefilecsidriver-v${VERSION}-sample.yaml
```

**Note:** For testing unreleased bundles sitting in a developers private registry, replace REPO with the private registry, i.e. `quay.io/datamattsson`. To pull the `HPECSIDriver` sample file from an unmerged PR, replace BRANCH with `refs/heads/<branch name>`

To cleanup or allow re-deploy:

```
operator-sdk cleanup hpe-filex-csi-operator -n hpe-storage
```
