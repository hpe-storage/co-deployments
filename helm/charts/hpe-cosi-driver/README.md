## HPE COSI Driver for Kubernetes Helm Chart

The HPE COSI Driver for Kubernetes leverages Hewlett Packard Enterprise object storage platforms to provide scalable S3 compatible object storage for workloads running on Kubernetes. Currently supported object storage platforms include HPE Alletra Storage MP X10000.

## Release Highlights

The HPE COSI Driver for Kubernetes Helm chart is the primary delivery vehicle for the HPE COSI Driver.

- All resources for the HPE COSI Driver is available on [HPE Storage Container Orchestrator Documentation](https://scod.hpedev.io/cosi_driver) (SCOD).
- Visit [the latest release](https://scod.hpedev.io/cosi_driver/index.html#latest_release) on SCOD to learn what's new in this chart.
- The release notes for the HPE COSI Driver are hosted on [GitHub](https://github.com/hpe-storage/cosi-driver/tree/master/release-notes).

## Prerequisites

1. Kubernetes version v1.25 or later
2. Helm version v3.11 or later
3. HPE Alletra Storage MP X10000 object storage details:
	- Backend protocol used: S3
	- Features available to the COSI driver: Bucket creation and deletion, granting and revoking bucket access

## Configuration and Installation

The following parameters are supported by the Helm chart. During normal circumstances, these can be left at their default values.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| accessManagement.glcpCommonCloud | string | `"sso.common.cloud.hpe.com"` | HPE GLCP common cloud URL |
| accessManagement.proxy | string | `""` | Proxy url if any to be used |
| componentName | string | `"container-object-storage-interface"` |  |
| containers.cosiDriver.image | string | `"quay.io/hpestorage/cosi-driver:v1.0.0"` | Fully qualified registry path of cosiDriver |
| containers.cosiDriver.imagePullPolicy | string | `"IfNotPresent"` | cosiDriver image pull policy |
| containers.cosiDriver.name | string | `"hpe-cosi-driver"` | Name of the driver's container within the deployment |
| containers.sideCar.image | string | `"gcr.io/k8s-staging-sig-storage/objectstorage-sidecar:v20241017-v0.1.0-58-g80979e8"` | Fully qualified registry path of sideCar |
| containers.sideCar.imagePullPolicy | string | `"IfNotPresent"` | sideCar image pull policy |
| containers.sideCar.name | string | `"hpe-cosi-provisioner-sidecar"` | Name of the driver's side car container within the deployment |
| containers.sideCar.verbosityLevel | int | `5` | Specifies the verbosity of the logs that will be printed by the sidecar container |
| deployment.name | string | `"hpe-cosi-provisioner"` | The name of the driver's Kubernetes deployment |
| fullnameOverride | string | `"hpe-cosi-driver"` | Name of deployment |
| namespace | string | `"default"` | Namespace must remain default |
| podEvictionToleration | int | `300` | Pod Toleration time in seconds |
| regSecretName | string | `""` | Secret that contains the private image registry credentials to pull the cosiDriver image |
| resources | object | `{}` | Resources such as CPU limits, Memory limits, CPU request and Memory request applied to the COSI driver and the COSI sidecar individually. |

Learn how to specify resource limits and requests in the official documentation on [kubernetes.io](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

## Installation Steps

1. Create the custom resource definitions (CRDs) for the COSI driver API resources.

```
kubectl apply -k github.com/kubernetes-sigs/container-object-storage-interface-api
```

2. Deploy the object storage controller.

```
kubectl apply -k github.com/kubernetes-sigs/container-object-storage-interface-controller
```

**Note:** The SIG Storage resourcs are deployed in the "default" `Namespace` and the HPE COSI Driver needs to be deployed there as well. See [known limitations](https://scod.hpedev.io/cosi_driver/index.html#known_limitations) for more information.

3. Installing the chart.

To install the chart with the name "my-hpe-cosi-driver", follow this example.

Add HPE helm repo:

```
helm repo add hpe-storage https://hpe-storage.github.io/co-deployments/
helm repo update
```

Install the latest chart:

```
helm install -n default my-hpe-cosi-driver hpe-storage/hpe-cosi-driver
```

Monitor the deployment of the COSI driver `Pods`:

```
kubectl -n default get pods -w
```

## Using

Refer to the [HPE COSI Driver for Kubernetes](https://scod.hpedev.io/cosi_driver/deployment.html#add_an_hpe_storage_backend) documentation on SCOD. Also, it's helpful to be familiar with [object storage management](https://kubernetes.io/blog/2022/09/02/cosi-kubernetes-object-storage-management/) in Kubernetes prior to deploying workloads utilizing object storage.

## License

This is open source software licensed using the Apache License 2.0. Please see [LICENSE](https://github.com/hpe-storage/co-deployments/blob/master/LICENSE) for details.
