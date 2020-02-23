
# HPE CSI Driver for Kubernetes Helm chart
The [HPE CSI Driver for Kubernetes](https://github.com/hpe-storage/csi-driver) leverages HPE storage platforms to provide scalable and persistent storage for stateful applications.

## Prerequisites

- Upstream Kubernetes version > 1.13
- Other Kubernetes distributions supported
- OpenShift 4.2 in Tech Preview (3.x is not supported, see [FlexVolume Driver Helm chart](https://github.com/hpe-storage/co-deployments/tree/master/helm/charts/hpe-flexvolume-driver))
- More distributions will be listed as tests are ongoing
- Recent Ubuntu, CentOS or RHEL compute nodes connected to their respective official package repositories
- Helm 3.x is not supported with v1.0.0 release.

Depending on which [Container Storage Provider](https://github.com/hpe-storage/container-storage-provider) (CSP) is being used, other prerequisites and requirements may apply.

### HPE Nimble Storage CSP
- NimbleOS 5.0.x or later

## Configuration & Installation
The following table lists the configurable parameters of the HPE-CSI chart and their default values.

|  Parameter                |  Description                                                |  Default    |
|---------------------------|-------------------------------------------------------------|-------------|
| secret.name                   | Name of the secret to create along with driver deployment                 | nimble-secret |
| secret.create                   | Enabled creation of secret along with driver deployment                 | 192.168.1.1 |
| secret.backend                   | HPE storage backend hostname or IP address.                 | 192.168.1.1 |
| secret.username                  | Username for the backend.                                   | admin       |
| secret.password                  | Password for the backend.                                   | admin       |
| crd.nodeInfo.create       | Create nodeinfo CRDs required by HPE CSI driver. Should only enable with helm 2.x, as they are automatically created with helm 3.x without this flag.                  | false        |
| logLevel             | Log level. Can be one of `info`, `debug`, `trace`, `warn` and `error`                                        | info         |
| imagePullPolicy | Image pull policy (Always, IfNotPresent, Never).                                          | Always |
| storageClass.name  | The name to assign the created StorageClass.                                          | hpe-standard |
| storageClass.create | Enables creation of StorageClass to consume this hpe-csi-driver instance using secret as secret.name variable                              | true        |
| storageClass.defaultClass | Whether to set the created StorageClass as the clusters default StorageClass.                                | false       |
| storageClass.parameters.fsType                    | Type of file system being used (ext4, ext3, xfs, btrfs)     | xfs         |
| storageClass.parameters.volumeDescription         | Volume description for volumes created using HPE CSI driver     | -         |
| storageClass.parameters.accessProtocol            | Access protocol to use for storage connectivity (iscsi, fc)     | iscsi         |

It's recommended to create a [values.yaml](https://github.com/hpe-storage/co-deployments/blob/master/helm/values/csi-driver) file from corresponding release and edit it to fit the environment the chart is being deployed to. Download and edit the sample file.

**Note:** HPE CSI Driver for Kubernetes automatically configures Linux iSCSI/Multipath settings based on [config.json](https://raw.githubusercontent.com/hpe-storage/co-deployments/master/helm/charts/hpe-csi-driver/files/config.json). In order to tune these values, edit the config map with `kubectl edit configmap hpe-linux-config -n kube-system` and restart node plugin using `kubectl delete pod -l app=hpe-csi-node` to apply.

### Installing the Chart
To install the chart with the name `hpe-csi`:

```
helm repo add hpe https://hpe-storage.github.io/co-deployments
helm install --name hpe-csi hpe/hpe-csi-driver --namespace kube-system -f myvalues.yaml
```

**Note:** Omitting the `--name` flag will generate a human readable name.

### Uninstalling the Chart
To uninstall/delete the `hpe-csi` deployment:

```
helm delete hpe-csi --purge
```

### Alternative install method
In some cases it's more practical to provide the local configuration via the `helm` command directly. Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```
helm install --name hpe-csi hpe/hpe-csi-driver \
--set backend=X.X.X.X --set username=admin --set password=xxxxxxxxx
```

## Using
To enable dynamic provisioning of volumes through the use of `PersistentVolumeClaim` API objects, a `StorageClass` needs to be declared on the cluster. Please see the [HPE CSI Driver for Kubernetes](https://github.com/hpe-storage/csi-driver) repository for the official documentation for this Helm chart. Also, it's helpful to be familar with [persistent storage concepts](https://kubernetes.io/docs/concepts/storage/volumes/) in Kubernetes prior to deploying stateful workloads.

## Support
The HPE CSI Driver for Kubernetes Helm chart is covered by your HPE support contract. Please file any issues, questions or feature requests [here](https://github.com/hpe-storage/co-deployments/issues) or contact HPE through the regular support channels. You may also join our Slack community to chat with HPE folks close to this project. We hang out in `#NimbleStorage` and `#Kubernetes` at [slack.hpedev.io](https://slack.hpedev.io/).

## Contributing
We value all feedback and contributions. If you find any issues or want to contribute, please feel free to open an issue or file a PR. More details in [CONTRIBUTING.md](https://github.com/hpe-storage/co-deployments/blob/master/CONTRIBUTING.md)

## License
This is open source software licensed using the Apache License 2.0. Please see [LICENSE](https://github.com/hpe-storage/co-deployments/blob/master/LICENSE) for details.
