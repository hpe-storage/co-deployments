# HPE CSI Operator for Kubernetes

## Overview
The HPE CSI Operator packages, deploys, manages, upgrades HPE CSI Driver on Kubernetes and OpenShift for dynamic provisioning of persistent volumes on HPE storage systems.

This Operator is created as a [Custom Resource Definition](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/#customresourcedefinitions) from the [hpe-csi-driver Helm chart](https://github.com/hpe-storage/co-deployments/tree/master/helm/charts/hpe-csi-driver) using the [Operator-SDK](https://github.com/operator-framework/operator-sdk#overview).

**Note:** This installation process does NOT require Helm. Also if need to install using OLM, please refer to install steps from [OperatorHub.io](https://operatorhub.io/operator/hpe-csi-driver-operator) install page. If using OCP console, below steps doesn't apply as well.

## Platform and Software Dependencies
For platform dependencies for the HPE CSI Driver please refer to [prerequisites](https://github.com/hpe-storage/co-deployments/tree/master/helm/charts/hpe-csi-driver#prerequisites).

## Installation on OpenShift
Please follow usual steps to deploy Operator through OCP console from Operator catalog. Once operator is deployed, create HPECSIDriver instance with required values like `backend`, `username`, and `password`. This will deploy HPE CSI driver under same project.

## Installation on Kubernetes
Please follow steps from install page of [OperatorHub](https://operatorhub.io/operator/hpe-csi-driver-operator). Once operator is installed, HPECSIDriver CustomResource should be installed in namespace `my-hpe-csi-driver-operator`. CustomResource sample can be found at OperatorHub as well.

## Using the HPE CSI Driver for Kubernetes
Refer to the [CSI driver repository](https://github.com/hpe-storage/csi-driver#using-the-hpe-csi-driver-for-kubernetes) for examples on usage and `StorageClass` examples for the various platforms supported by the driver.

## License
This is open source software licensed using the Apache License 2.0. Please see [LICENSE](../../LICENSE) for details.
