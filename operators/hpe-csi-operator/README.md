# HPE CSI Operator

## Overview
The HPE CSI Operator packages, deploys, manages, upgrades HPE CSI Driver on Kubernetes and OpenShift for dynamic provisioning of persistent volumes on HPE storage systems.

This Operator is created as a [Custom Resource Definition](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/#customresourcedefinitions) from the [hpe-csi-driver Helm chart](https://github.com/hpe-storage/co-deployments/tree/master/helm/charts/hpe-csi-driver) using the [Operator-SDK](https://github.com/operator-framework/operator-sdk#overview).

This installation process does not require Helm installation.

## Platform and Software Dependencies
For platform dependencies for HPE CSI driver please refer to [prerequisites](https://github.com/hpe-storage/co-deployments/tree/master/helm/charts/hpe-csi-driver#prerequisites)

## Installation

For OCP create SecurityContextConstraints with privileges required for CSI driver
```
oc apply -f https://raw.githubusercontent.com/hpe-storage/co-deployments/master/operators/hpe-csi-operator/deploy/scc.yaml -n hpe-csi
```

*** NOTE *** If you are using OpenShift, replace `kubectl` with `oc` below.

Deploy Operator/RBAC and CRD's required
```
kubectl apply -f https://raw.githubusercontent.com/hpe-storage/co-deployments/master/operators/hpe-csi-operator/deploy/rbac.yaml -n hpe-csi
kubectl apply -f https://raw.githubusercontent.com/hpe-storage/co-deployments/master/operators/hpe-csi-operator/deploy/operator.yaml -n hpe-csi
kubectl apply -f https://raw.githubusercontent.com/hpe-storage/co-deployments/master/operators/hpe-csi-operator/deploy/crds/storage.hpe.com_hpecsidrivers_crd.yaml -n hpe-csi
```

Fetch and update CustomResource of type `HPECSIDriver` with required values
```
curl -sL https://raw.githubusercontent.com/hpe-storage/co-deployments/master/operators/hpe-csi-operator/deploy/crds/storage.hpe.com_v1_hpecsidriver_cr.yaml > storage.hpe.com_v1_hpecsidriver_cr.yaml
```

Deploy above updated CustomResource `csi-driver`
```
kubectl apply -f storage.hpe.com_v1_hpecsidriver_cr.yaml -n hpe-csi
```

where ``hpe-csi`` is the project/namespace in which the HPE CSI Operator is installed. It is **strongly recommended** to install the HPE CSI Operator in a new project and not add any other pods to this project/namespace. Any pods in this project will be cleaned up on an uninstall.

## Upgrading

Fetch and update CustomResource of type `HPECSIDriver` with required values
```
curl -sL https://raw.githubusercontent.com/hpe-storage/co-deployments/master/operators/hpe-csi-operator/deploy/crds/storage.hpe.com_v1_hpecsidriver_cr.yaml > storage.hpe.com_v1_hpecsidriver_cr.yaml
```

Deploy updated CustomResource `csi-driver`
```
kubectl deploy -f storage.hpe.com_v1_hpecsidriver_cr.yaml -n hpe-csi
```

### How to upgrade from helm install to HPE CSI Operator
This upgrade will not impact the in-use volumes/filesystems from data path perspective. However, it will affect the in-flight volume/filesystem management operations. So, it is recommended to stop all the volume/filesystem management operations before doing this upgrade. Otherwise, these operations may need to be retried after the upgrade.

Remove the helm-chart using instructions in https://helm.sh/docs/using_helm/#uninstall-a-release.
Once the helm chart has been uninstalled, follow the install instructions [above.](#installation)

## Uninstall

*** NOTE *** If you are using OpenShift, replace `kubectl` with `oc`.

1. Delete the HPE CSI Driver custom resource, this will cause our CSI plugin resources to be cleaned up.
```
kubectl delete -f https://raw.githubusercontent.com/hpe-storage/co-deployments/master/operators/hpe-csi-operator/deploy/crds/storage.hpe.com_v1_hpecsidriver_cr.yaml -n hpe-csi

kubectl delete -f https://raw.githubusercontent.com/hpe-storage/co-deployments/master/operators/hpe-csi-operator/deploy/crds/storage.hpe.com_hpecsidrivers_crd.yaml -n hpe-csi
```

If the CRD fails to delete you may be experiencing a known issue. Resolve this by running:
```
kubectl patch crd/hpecsidrivers.storage.hpe.com -p '{"metadata":{"finalizers":[]}}' --type=merge
```

2. Delete all cluster level roles and bindings for operator
```
kubectl delete -f https://raw.githubusercontent.com/hpe-storage/co-deployments/master/operators/hpe-csi-operator/deploy/rbac.yaml -n hpe-csi
```

For OpenShift, delete SecurityContextConstraints created
```
kubectl delete -f https://raw.githubusercontent.com/hpe-storage/co-deployments/master/operators/hpe-csi-operator/deploy/scc.yaml -n hpe-csi
```

3. Delete operator deployment itself
```
kubectl delete -f https://raw.githubusercontent.com/hpe-storage/co-deployments/master/operators/hpe-csi-operator/deploy/operator.yaml -n hpe-csi
```

where ``hpe-csi`` is the project/namespace in which the HPE CSI Operator is installed. It is **strongly recommended** to install the HPE CSI Operator in a new project and not add any other pods to this project/namespace. Any pods in this project will be cleaned up on an uninstall.

## License
This is open source software licensed using the Apache License 2.0. Please see [LICENSE](../../LICENSE) for details.
