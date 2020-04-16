# HPE CSI Operator for Kubernetes

## Overview
The HPE CSI Operator packages, deploys, manages, upgrades HPE CSI Driver on Kubernetes and OpenShift for dynamic provisioning of persistent volumes on HPE storage systems.

This Operator is created as a [Custom Resource Definition](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/#customresourcedefinitions) from the [hpe-csi-driver Helm chart](https://github.com/hpe-storage/co-deployments/tree/master/helm/charts/hpe-csi-driver) using the [Operator-SDK](https://github.com/operator-framework/operator-sdk#overview).

**Note:** This installation process does NOT require Helm. Also if need to install using OLM, please refer to install steps from [OperatorHub.io](https://operatorhub.io/operator/hpe-csi-driver-operator) install page. If using OCP console, below steps doesn't apply as well.

## Platform and Software Dependencies
For platform dependencies for the HPE CSI Driver please refer to [prerequisites](https://github.com/hpe-storage/co-deployments/tree/master/helm/charts/hpe-csi-driver#prerequisites).

## Installation on OpenShift

HPE CSI Driver needs to run in privileged mode and needs access to host ports, host network and should be able to mount hostPath volumes. Hence, before deploying HPE CSI operator on OCP, please create a `SecurityContextConstraints` to allow our driver to be running with these privileges.

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

After this, please follow usual steps to deploy Operator through OCP console from Operator catalog under same project as specified in SCC above. Once operator is deployed, create HPECSIDriver instance with required values like `backend`, `username`, and `password`. This will deploy HPE CSI driver under same project.

## Installation on Kubernetes
Please follow steps from install page of [OperatorHub](https://operatorhub.io/operator/hpe-csi-driver-operator). Once operator is installed, HPECSIDriver CustomResource should be installed in namespace `my-hpe-csi-driver-operator`. CustomResource sample can be found at OperatorHub as well.

## Using the HPE CSI Driver for Kubernetes
Refer to the [CSI driver repository](https://github.com/hpe-storage/csi-driver#using-the-hpe-csi-driver-for-kubernetes) for examples on usage and `StorageClass` examples for the various platforms supported by the driver.

## License
This is open source software licensed using the Apache License 2.0. Please see [LICENSE](../../LICENSE) for details.
