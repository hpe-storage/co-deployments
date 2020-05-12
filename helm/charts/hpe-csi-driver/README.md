# HPE CSI Driver for Kubernetes Helm chart

The [HPE CSI Driver for Kubernetes](https://scod.hpedev.io/csi_driver/index.html) leverages HPE storage platforms to provide scalable and persistent storage for stateful applications.

## Prerequisites

- Upstream Kubernetes version >= 1.13
- Most Kubernetes distributions are supported
- Recent Ubuntu, CentOS or RHEL compute nodes connected to their respective official package repositories
- Helm 2 (Should specify creation of CRD's explicitly using `--set crd.nodeInfo.create=true` during install)
- Helm 3 (Supported only from HPE CSI Driver version 1.1.0 onwards)

Depending on which [Container Storage Provider](https://scod.hpedev.io/container_storage_provider/index.html) (CSP) is being used, other prerequisites and requirements may apply, such as storage platform OS and features.

- [HPE Nimble Storage](https://scod.hpedev.io/container_storage_provider/hpe_nimble_storage/index.html)
- [HPE 3PAR and Primera](https://scod.hpedev.io/container_storage_provider/hpe_3par_primera/index.html)

## Configuration and installation

The following table lists the configurable parameters of the HPE-CSI chart and their default values.

|  Parameter                |  Description                                                |  Default    |
|---------------------------|-------------------------------------------------------------|-------------|
| backendType                   | Name of the HPE storage backend type (nimble, primera3par).                 | nimble |
| secret.create                   | Enable creation of a `Secret` along with CSP deployment.                 | true |
| secret.backend                   | HPE storage backend hostname or IP address.                 | 192.168.1.1 |
| secret.username                  | Username for the backend.                                   | admin       |
| secret.password                  | Password for the backend.                                   | admin       |
| crd.nodeInfo.create       | Create `hpenodeinfo` CRDs required by HPE CSI Driver. Should only be enabled with Helm 2, as they are automatically created with Helm 3 without this flag.                  | false        |
| crd.volumeInfo.create       | Create `hpevolumeinfo` CRDs required by HPE CSI Driver for 3PAR and Primera. Should only be enabled with Helm 2, as they are automatically created with Helm 3 without this flag. | false        |
| logLevel             | Log level. Can be one of `info`, `debug`, `trace`, `warn` and `error`.                                        | info         |
| imagePullPolicy | Image pull policy (`Always`, `IfNotPresent`, `Never`).                                          | Always |
| storageClass.name  | The name to assign the created `StorageClass`.                                          | hpe-standard |
| storageClass.create | Enables creation of a `StorageClass` managed by this Helm chart.                            | true        |
| storageClass.defaultClass | Whether to set the created `StorageClass` as the clusters default `StorageClass`.                                | false       |
| storageClass.parameters.fsType                    | Type of file system being used (ext4, ext3, xfs, btrfs).     | xfs         |
| storageClass.parameters.volumeDescription         | Default volume description set on backend volume.     | -         |
| storageClass.parameters.accessProtocol            | Access protocol to use for storage connectivity (iscsi, fc).     | iscsi         |

> **Note**: The provided `StorageClass` is currently not compatible with `backendType: primera3par`.
> How to setup a `StorageClass` for HPE 3PAR and Primera is documented on [SCOD](https://scod.hpedev.io/container_storage_provider/hpe_3par_primera/).

It's recommended to create a [values.yaml](https://github.com/hpe-storage/co-deployments/blob/master/helm/values/csi-driver) file from the corresponding release of the chart and edit it to fit the environment the chart is being deployed to. Download and edit [a sample file](https://github.com/hpe-storage/co-deployments/blob/master/helm/values/csi-driver).

These are the bare minimum required parameters for a successful deployment to an iSCSI enviornment:

```
# nimble or primera3par
backendType: nimble
secret:
  backend: 192.168.1.1
  username: admin
  password: admin
```

Tweak any additional parameters to suit the environment or as prescribed by HPE.

### Installing the chart

To install the chart with the name `hpe-csi`:

Add HPE helm repo:
```
helm repo add hpe https://hpe-storage.github.io/co-deployments
helm repo update
```

Install the latest chart:
```
# Helm 3
helm install hpe-csi hpe/hpe-csi-driver --namespace kube-system -f myvalues.yaml

# Helm 2, for Nimble, Install with HPENodeInfos CRD's enabled explicitly
helm install --name hpe-csi hpe/hpe-csi-driver --namespace kube-system -f myvalues.yaml --set crd.nodeInfo.create=true
```

### Upgrading the Chart

To upgrade the chart, specify the version you want to upgrade to as below. Please do NOT re-use a full blown `values.yaml` from prior versions to upgrade to later versions. Always use `values.yaml` from corresponding release from [values.yaml](https://github.com/hpe-storage/co-deployments/blob/master/helm/values/csi-driver)

```
# List the avaiable version of the plugin:
helm repo update
helm search repo hpe-csi-driver -l

# Select the target version to upgrade as below:
helm upgrade hpe-csi hpe/hpe-csi-driver --namespace kube-system --version=x.x.x.x -f myvalues.yaml
```

### Uninstalling the Chart

To uninstall (Helm 3) or delete (Helm 2) the `hpe-csi` chart:

```
# Helm 3
helm uninstall hpe-csi --namespace kube-system

# Helm 2
helm delete hpe-csi --purge
```

> **Note**: Due to a limitation in Helm, CRDs are not deleted as part of the chart uninstall.

### Alternative install method

In some cases it's more practical to provide the local configuration via the `helm` CLI directly. Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. These will take precedence over entries in [values.yaml](https://github.com/hpe-storage/co-deployments/blob/master/helm/values/csi-driver). For example:

```
# Helm 3
helm install hpe-csi hpe/hpe-csi-driver --namespace kube-system --set backendType=nimble \
--set backend=X.X.X.X --set username=admin --set password=xxxxxxxxx

# Helm 2
helm install --name hpe-csi hpe/hpe-csi-driver --namespace kube-system --set backendType=nimble \
--set backend=X.X.X.X --set username=admin --set password=xxxxxxxxx
```

## Using persistent storage for Kubernetes

To enable dynamic provisioning of volumes through the use of `PersistentVolumeClaim` API objects, a `StorageClass` needs to be declared on the cluster. By default, a `StorageClass` named `hpe-standard` is installed on the cluster. Please see the [HPE CSI Driver for Kubernetes](https://scod.hpedev.io/csi_driver/index.html) documentation on [SCOD](https://scod.hpedev.io) for the official documentation of the HPE CSI Driver for Kubernetes. Also, it's helpful to be familar with [persistent storage concepts](https://kubernetes.io/docs/concepts/storage/volumes/) in Kubernetes prior to deploying stateful workloads.

## Support

The HPE CSI Driver for Kubernetes Helm chart is covered by your HPE support contract. Please file any issues, questions or feature requests [here](https://github.com/hpe-storage/co-deployments/issues) or contact HPE through the regular support channels. You may also join our Slack community to chat with HPE folks close to this project. We hang out in `#NimbleStorage`, `#3par-primera` and `#Kubernetes` at [hpedev.slack.com](https://hpedev.slack.com), sign up here: [slack.hpedev.io](https://slack.hpedev.io/).

## Contributing

We value all feedback and contributions. If you find any issues or want to contribute, please feel free to open an issue or file a PR. More details in [CONTRIBUTING.md](https://github.com/hpe-storage/co-deployments/blob/master/CONTRIBUTING.md)

## License

This is open source software licensed using the Apache License 2.0. Please see [LICENSE](https://github.com/hpe-storage/co-deployments/blob/master/LICENSE) for details.
