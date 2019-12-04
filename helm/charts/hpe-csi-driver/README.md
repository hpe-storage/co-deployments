
# HPE CSI Driver for Kubernetes Helm chart
The [HPE CSI Driver for Kubernetes](https://github.com/hpe-storage/csi-driver) leverages HPE storage platforms to provide scalable and persistent storage for stateful applications.

## Prerequisites

- Upstream Kubernetes version > 1.12
- Other Kubernetes distributions supported
- OpenShift 4.1 in Tech Preview (3.x is not supported, see [FlexVolume Driver Helm chart](https://github.com/hpe-storage/co-deployments/tree/master/helm/charts/hpe-flexvolume-driver))
- More distributions will be listed as tests are ongoing
- Recent Ubuntu, CentOS or RHEL compute nodes connected to their respective official package repositories

Depending on which [Container Storage Provider](https://github.com/hpe-storage/container-storage-provider) (CSP) is being used, other prerequisites and requirements may apply.

### HPE Nimble Storage CSP
- NimbleOS 4.5.x or later

## Configuration & Installation
The following table lists the configurable parameters of the HPE-CSI chart and their default values.

|  Parameter                |  Description                                                |  Default    |
|---------------------------|-------------------------------------------------------------|-------------|
| backend                   | HPE storage backend hostname or IP address.                 | 192.168.1.1 |
| username                  | Username for the backend.                                   | admin       |
| password                  | Password for the backend.                                   | admin       |
| fsType                    | Type of file system being used (ext4, ext3, xfs, btrfs)     | xfs         |

It's recommended to create a [values.yaml](https://github.com/hpe-storage/co-deployments/blob/master/helm/charts/hpe-csi-driver/values.yaml) file and edit it to fit the environment the chart is being deployed to. Download and edit the sample file.

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
The HPE CSI Driver for Kubernetes Helm chart is considered beta software and only works with the HPE Nimble Storage CSP. Do not use for production and do not contact HPE for support. Please file any issues, questions or feature requests [here](https://github.com/hpe-storage/co-deployments/issues). You may also join our Slack community to chat with HPE folks close to this project. We hang out in `#NimbleStorage` and `#Kubernetes` at [slack.hpedev.io](https://slack.hpedev.io/).

## Contributing
We value all feedback and contributions. If you find any issues or want to contribute, please feel free to open an issue or file a PR. More details in [CONTRIBUTING.md](https://github.com/hpe-storage/co-deployments/blob/master/CONTRIBUTING.md)

## License
This is open source software licensed using the Apache License 2.0. Please see [LICENSE](https://github.com/hpe-storage/co-deployments/blob/master/LICENSE) for details.
