# HPE FlexVolume Driver for Kubernetes Helm Chart

## Introduction
The [HPE FlexVolume Driver for Kubernetes](https://github.com/hpe-storage/flexvolume-driver) leverages HPE storage platforms to provide scalable and persistent storage for stateful applications. This chart also deploys the [HPE Dynamic Provisioner for Kubernetes](https://github.com/hpe-storage/k8s-dynamic-provisioner).

## Prerequisites
- Upstream Kubernetes version > 1.10
- Other Kubernetes distributions supported
  - OpenShift 3.10, 3.11 (4.x will not be supported, see [CSI Helm chart](../hpe-csi-driver)
  - More distributions will be listed as tests are ongoing
- Recent Ubuntu, CentOS or RHEL compute nodes connected to their respective official package repositories

## Installing the Chart
To install the chart with the name `hpe-flexvolume`:
```
helm repo add hpe https://github.rtplab.nimblestorage.com/dcs/helm/
helm install --name hpe-flexvolume hpe/hpe-flexvolume-driver` --namespace kube-system
```
**Note:** Omitting the `--name` flag will generate a human readble name

## Uninstalling the Chart
To uninstall/delete the `hpe-flexvolume` deployment:

```
helm delete hpe-flexvolume --purge
```

## Testing the Chart
To test the chart with name `hpe-flexvolume`:

```
helm test hpe-flexvolume --cleanup
```

## Configuration
The following table lists the configurable parameters of the HPE FlexVolume Driver chart and their default values.

|  Parameter                |  Description                                                                                       |  Default    |
|---------------------------|----------------------------------------------------------------------------------------------------|------------ |
| backend                   | HPE storage platform API endpoint                                                                  | 192.168.1.1 |
| username                  | Username for the backend                                                                           | admin       |
| password                  | Password for the backen                                                                            | admin       |
| protocol                  | Data plane protocol (`fc`, `iscsi`)                                                                | iscsi       |
| fsType                    | Type of file to format volumes with (ext4, ext3, xfs, btrfs)                                       | xfs         |
| mountConflictDelay        | Wait this long (in seconds) before forcefully taking over a volume from an isolated or crashed node| 150         |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```
helm install --name hpe-flexvolume hpe/hpe-flexvolume-driver \
--set arrayIp=X.X.X.X --set username=admin --set password=xxxxxxxxx \
--set protocol=iscsi --set fsType=xfs --set mountConflictDelay=120
```

## Using


## Support
The HPE CSI Driver is considered beta software. Do not use for production and do not contact HPE for support. Please file any issues, questions or feature requests [here](https://github.com/hpe-storage/csi-driver/issues). You may also join our Slack community to chat with HPE folks close to this project. We hang out in `#NimbleStorage` and `#Kubernetes` at [slack.hpedev.io](https://slack.hpedev.io/).

## Contributing
We value all feedback and contributions. If you find any issues or want to contribute, please feel free to open an issue or file a PR. More details in [CONTRIBUTING.md](CONTRIBUTING.md)

## License
This is open source software licensed using the Apache License 2.0. Please see [LICENSE](LICENSE) for details.
