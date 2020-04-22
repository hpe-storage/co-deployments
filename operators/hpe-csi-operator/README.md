# HPE CSI Operator for Kubernetes

## Overview

The HPE CSI Operator packages, deploys, manages, upgrades HPE CSI Driver on Kubernetes and OpenShift for dynamic provisioning of persistent volumes on HPE storage systems.

This Operator is created as a [Custom Resource Definition](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/#customresourcedefinitions) from the [hpe-csi-driver Helm chart](https://hub.helm.sh/charts/hpe-storage/hpe-csi-driver) using the [Operator-SDK](https://github.com/operator-framework/operator-sdk#overview).

**Note:** This installation process does NOT require Helm. Also if need to install using OLM, please refer to install steps from [OperatorHub.io](https://operatorhub.io/operator/hpe-csi-driver-operator) install page. If using OCP console, below steps doesn't apply as well.

## Platform and Software Dependencies

For platform dependencies for the HPE CSI Driver please refer to [compatability and support](https://scod.hpedev.io/csi_driver/index.html#compatibility_and_support).

## Installation on OpenShift

The HPE CSI Driver needs to run in privileged mode and needs access to host ports, host network and should be able to mount hostPath volumes. Hence, before deploying HPE CSI Operator on OCP, please create a `SecurityContextConstraints` to allow the CSI driver to be running with these privileges.

Get SCC:
```
curl -sL https://raw.githubusercontent.com/hpe-storage/co-deployments/master/operators/hpe-csi-operator/deploy/scc.yaml > hpe-csi-scc.yaml
```

Change `my-hpe-csi-driver-operator` to the name of the project(eg `my-project-name` below) where CSI operator is being deployed
```
sed -i 's/my-hpe-csi-driver-operator/my-project-name/g' hpe-csi-scc.yaml
```

Deploy SCC:
```
oc create -f hpe-csi-scc.yaml
```

Once the SCC has been deployed, please follow the official Red Hat OpenShift steps to deploy Operators through the OCP console from Operator catalog. It needs to be under the same project as specified in the SCC above. Once the Operator is deployed, create a HPECSIDriver instance with required values like `backendType`, `backend`, `username`, and `password`. This will deploy the HPE CSI Driver under the same project.

## Installation on Kubernetes

Please follow the steps from the install page on [OperatorHub.io](https://operatorhub.io/operator/hpe-csi-driver-operator). Once the operator is installed, `HPECSIDriver` `CustomResource` should be installed in namespace `my-hpe-csi-driver-operator`. A `CustomResource` sample can be found at OperatorHub.io as well.

## Using the HPE CSI Driver for Kubernetes

Refer to the official [HPE CSI Driver for Kubernetes](https://scod.hpedev.io/csi_driver/index.html) for examples on usage and `StorageClass` examples for the various storage platforms supported by the driver.

## License

This is open source software licensed using the Apache license 2.0. Please see [LICENSE](https://github.com/hpe-storage/co-deployments/blob/master/LICENSE) for details.
