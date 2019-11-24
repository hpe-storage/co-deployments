# HPE FlexVolume Driver Operator

## Overview
The HPE FlexVolume Driver Operator packages, deploys, manages, upgrades HPE FlexVolume Driver on Kubernetes and OpenShift for dynamic provisioning of persistent volumes on HPE storage systems.

This Operator is created as a [Custom Resource Definition](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/#customresourcedefinitions) from the [hpe-flexvolume-driver Helm chart](https://github.com/hpe-storage/co-deployments/tree/master/helm/charts/hpe-flexvolume-driver) using the [Operator-SDK](https://github.com/operator-framework/operator-sdk#overview).

This installation process does not require Helm installation.

## Platform and Software Dependencies
For platform dependencies for HPE FlexVolume driver please refer to [prerequisites](https://github.com/hpe-storage/co-deployments/tree/master/helm/charts/hpe-flexvolume-driver#prerequisites)

## Installation

Clone this GitHub repository.<br/>
```
git clone https://github.com/hpe-storage/co-deployments
cd operators/hpe-flexvolume-operator
```

Create your own `values.yaml`. The easiest way is to copy the default [values.yaml](../../helm/charts/hpe-flexvolume-driver/values.yaml) with `wget` and change parameters like `backend` as necessary.

Run the install script to set up the HPE FlexVolume Driver Operator.
```install.sh --image=<image> --namespace=<namespace> --flavor=<co flavor> --values=<values.yaml file path>```

Parameter list:<br/>
1. ``image`` is the HPE FlexVolume Driver Operator image. If unspecified ``image`` resolves to the released version at [hpestorage/flexvolume-driver-operator](https://hub.docker.com/repository/docker/hpestorage/flexvolume-driver-operator).
2. ``namespace`` is the namespace/project in which the HPE FlexVolume Driver Operator and its entities will be installed. If unspecified, the operator creates and installs in  the ``hpe-flexvolume`` namespace.
**HPE FlexVolume Driver Operator MUST be installed in a new project with no other pods. Otherwise an uninstall may delete pods that are not related to the HPE FlexVolume Driver Operator.**
3. ``flavor`` defaults to ``k8s``. Options are ``k8s``, ``ocp``, ``rke`` ``aks`` ``eks`` ``gke`` or ``gkeop``.
4. ``values.yaml`` is the customized helm-chart configuration parameters. This is a **required parameter** and must contain a valid backend HPE storage system. All parameters that need a non-default value must be specified in this file.
Refer to [Configuration for values.yaml.](https://github.com/hpe-storage/co-deployments/tree/master/helm/charts/hpe-flexvolume-driver#configuration--installation) for details about various parameters.

### Install script steps:
The install script will do the following:
1. Create New Project.<br/>
The script creates a new project (if it does not already exist) with the given namespace. If no namespace parameter is specified, the ``hpe-flexvolume`` namespace is used.<br/>

2. Create a Custom Resource Definition (CRD) for the HPE FlexVolume Driver Operator. <br/>
The script waits for the CRD to be published in the cluster. If after 10 seconds the API server has not setup the CRD, the script times out.

3. Create RBAC rules for the Operator.<br/>
The HPE FlexVolume Driver Operator needs the following Cluster-level Roles and RoleBindings.


| Resource        | Permissions           | Notes  |
| ------------- |:-------------:| -----:|
| Namespace | Get | HPE FlexVolume Driver Operator needs the ability to get created namespaces |
| Storageclass | Create/Delete | Create and cleanup storage classes to be used for Provisioning |
| ClusterRoleBinding | Create/Delete/Get | HPE Operator needs to create and cleanup a ClusterRoleBinding used by the external-provisioner/external-attacher/external-snapshotter/external-resizer sidecars |
<br/>

In addition, the operator needs access to multiple resources in the project/namespace that it is deployed in to function correctly. Hence it is recommended to install the HPE FlexVolume Driver Operator in the non-default namespace.
<br/>

4. Creates a deployment for the Operator.<br/>
Finally the script creates and deploys the operator using the customized parameters passed in the ``values.yaml`` file.

## Upgrading

### How to upgrade from helm install to HPE FlexVolume Driver Operator
This upgrade will not impact the in-use volumes/filesystems from data path perspective. However, it will affect the in-flight volume/filesystem management operations. So, it is recommended to stop all the volume/filesystem management operations before doing this upgrade. Otherwise, these operations may need to be retried after the upgrade.

Remove the helm-chart using instructions in https://helm.sh/docs/using_helm/#uninstall-a-release.
Once the helm chart has been uninstalled, follow the install instructions [above.](#installation)

### Apply changes in ``values.yaml``
The ``update.sh`` script is used to apply changes from ``values.yaml`` as follows.
```
./update.sh -f values.yaml
```

## Uninstall
To uninstall the HPE FlexVolume Driver Operator, run
```
kubectl delete all --all -n <hpe-flexvolume-operator-installed-namespace>
```
where ``hpe-flexvolume-operator-installed-namespace`` is the project/namespace in which the HPE FlexVolume Driver Operator is installed. It is **strongly recommended** to install the HPE FlexVolume Driver Operator in a new project and not add any other pods to this project/namespace. Any pods in this project will be cleaned up on an uninstall.

If you are using OpenShift, replace `kubectl` with `oc`.
To completely remove the CustomResourceDefinition used by the Operator run
```
kubectl delete crd hpeflexvolumedrivers.storage.hpe.com
```
If the CRD fails to delete you may be experiencing a known issue. Resolve this by running:
```
kubectl patch crd/hpeflexvolumedrivers.storage.hpe.com -p '{"metadata":{"finalizers":[]}}' --type=merge
```
If you are using OpenShift, replace `kubectl` with `oc` in the above commands.

## License
This is open source software licensed using the Apache License 2.0. Please see [LICENSE](../../LICENSE) for details.
