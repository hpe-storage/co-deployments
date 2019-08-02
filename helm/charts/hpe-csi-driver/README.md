# HPE CSI Driver for Kubernetes Helm chart
The [HPE CSI Driver for Kubernetes](https://github.com/hpe-storage/csi-driver) leverages HPE storage platforms to provide scalable and persistent storage for stateful applications.

## Prerequisites
- Upstream Kubernetes version > 1.10
- Other Kubernetes distributions supported
  - OpenShift 4.1 in Tech Preview (3.x is not supported, see [FlexVolume Helm chart](../hpe-flexvolume-driver))
  - More distributions will be listed as tests are ongoing
- Recent Ubuntu, CentOS or RHEL compute nodes connected to their respective official package repositories

## Configuration & Installation
The following table lists the configurable parameters of the HPE-CSI chart and their default values.

|  Parameter                |  Description                                                |  Default   |
|---------------------------|-------------------------------------------------------------|------------|
| backend                   | HPE Nimble Storage array IP                                 | 192.168.1.1|
| username                  | name used for the admin role                                | admin      |
| password                  | password for the admin role                                 | admin      |
| fsType                    | type of file system you are using (ext4, ext3, xfs, btrfs)  | xfs        |

It's recommended to create a [values.yaml](values.yaml) file and edit it to fit the environment the chart is being deployed to. Download and edit the sample file.

### Installing the Chart
To install the chart with the name `hpe-csi`:
```
helm repo add hpe https://github.com/hpe-storage/co-deployments/helm
helm install --name hpe-csi hpe/hpe-csi-driver --namespace kube-system
```
**Note:** Omitting the `--name` flag will generate a human readable name.

### Uninstalling the Chart
To uninstall/delete the `hpe-csi` deployment:
```
helm delete hpe-csi --purge
```

### Testing the Chart
To test the chart with name `hpe-csi`:
```
helm test hpe-csi --cleanup
```

### Alternative install method
In some cases it's more practical provide the local configuration via the `helm` command directly. Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:
```
helm install --name hpe-csi hpe/hpe-csi-driver \
--set backend=X.X.X.X --set username=admin --set password=xxxxxxxxx
```

## Using
To enable dynamic provisioning of volumes through the use of `PersistentVolumeClaim` API objects, a `StorageClass` needs to be declared on the cluster. Please see the [HPE CSI Driver for Kubernetes](https://github.com/hpe-storage/csi-driver) repository for the official documentation for this Helm chart. Also, it's helpful for be familar with [persistent storage concepts](https://kubernetes.io/docs/concepts/storage/volumes/) in Kubernetes prior to deploying stateful workloads.

## Support
The HPE CSI Driver for Kubernetes Helm chart is considered beta software. Do not use for production and do not contact HPE for support. Please file any issues, questions or feature requests [here](https://github.com/hpe-storage/co-deployments/issues). You may also join our Slack community to chat with HPE folks close to this project. We hang out in `#NimbleStorage` and `#Kubernetes` at [slack.hpedev.io](https://slack.hpedev.io/).

## Contributing
We value all feedback and contributions. If you find any issues or want to contribute, please feel free to open an issue or file a PR. More details in [CONTRIBUTING.md](CONTRIBUTING.md)

## License
This is open source software licensed using the Apache License 2.0. Please see [LICENSE](LICENSE) for details.
