# HPE Helm charts for

- [CSI Driver](#hpe-csi-driver-for-kubernetes-helm-chart)

- [FlexVolume Driver](#hpe-flexvolume-driver-for-kubernetes-helm-chart)

# HPE CSI Driver for Kubernetes Helm chart

The [HPE CSI Driver for Kubernetes](https://github.com/hpe-storage/csi-driver) leverages HPE storage platforms to provide scalable and persistent storage for stateful applications.

## Prerequisites

- Upstream Kubernetes version > 1.12

- Other Kubernetes distributions supported

- OpenShift 4.1 in Tech Preview (3.x is not supported, see [FlexVolume Helm chart](../helm/charts/hpe-flexvolume-driver))

- More distributions will be listed as tests are ongoing

- Recent Ubuntu, CentOS or RHEL compute nodes connected to their respective official package repositories

Depending on which [Container Storage Provider](https://github.com/hpe-storage/container-storage-provider) (CSP) is being used, other prerequisites and requirements may apply.

### HPE Nimble Storage CSP

- NimbleOS 4.6 or later

## Configuration & Installation
The following table lists the configurable parameters of the HPE-CSI chart and their default values.

|  Parameter                |  Description                                                |  Default    |
|---------------------------|-------------------------------------------------------------|-------------|
| backend                   | HPE storage backend hostname or IP address.                 | 192.168.1.1 |
| username                  | Username for the backend.                                   | admin       |
| password                  | Password for the backend.                                   | admin       |
| fsType                    | Type of file system being used (ext4, ext3, xfs, btrfs)     | xfs         |

It's recommended to create a [values.yaml](values.yaml) file and edit it to fit the environment the chart is being deployed to. Download and edit the sample file.

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

### Testing the Chart

To test the chart with the name `hpe-csi`:

```

helm test hpe-csi --cleanup

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


 ---
# HPE FlexVolume Driver for Kubernetes Helm chart

The [HPE FlexVolume Driver for Kubernetes](https://github.com/hpe-storage/flexvolume-driver) leverages HPE storage platforms to provide scalable and persistent storage for stateful applications. This chart also deploys the [HPE Dynamic Provisioner for Kubernetes](https://github.com/hpe-storage/k8s-dynamic-provisioner).

## Prerequisites

- Upstream Kubernetes version > 1.10

- Other Kubernetes distributions supported

- OpenShift 3.10, 3.11 (4.x will not be supported, see [CSI Helm chart](../helm/charts/hpe-csi-driver)

- More distributions will be listed as tests are ongoing

- Recent Ubuntu, CentOS or RHEL compute nodes connected to their respective official package repositories

Depending on which `pluginType` is being used, other prerequisites and requirements may apply.

### HPE Nimble Storage (nimble)

- NimbleOS 5.0.8 or later

## Configuration & Installation
The following table lists the configurable parameters of the HPE FlexVolume Driver chart and their default values.

|  Parameter                |  Description                                                                                       |  Default    |
|---------------------------|----------------------------------------------------------------------------------------------------|------------ |
| backend            | HPE storage platform API endpoint.                                                                   | 192.168.1.1 |
| pluginType         | Backend plugin type to use. Currently only `nimble` is supported.                                    | nimble      |
| username           | Username for the backend.                                                                            | admin       |
| password           | Password for the backend.                                                                            | admin       |
| protocol           | Data plane protocol (`fc`, `iscsi`).                                                                 | iscsi       |
| fsType             | Type of file to format volumes with (ext4, ext3, xfs, btrfs).                                        | xfs         |
| mountConflictDelay | Wait this long (in seconds) before forcefully taking over a volume from an isolated or crashed node. | 150         |
| flavor             | Kubernetes distribution specific tweaks. Currently only needed for `openshift`.                      | kubernetes           |
| podsMountDir       | This is the directory where the kubelet bind mounts the volume for pods. May differ between Kubernetes distributions.          | /var/lib/kubelet/pods     |
| flexVolumeExec     | This is the path where the FlexVolume binary gets installed on the host.                             | default     |
| storageClass.name  | The name to assign the created StorageClass.                                          | hpe-standard |
| storageClass.create | Enables creation of StorageClass to consume this hpe-flexvolume-driver instance.                              | true        |
| storageClass.defaultClass | Whether to set the created StorageClass as the clusters default StorageClass.                                  | false       |

It's recommended to create a [values.yaml](values.yaml) file and edit it to fit the environment the chart is being deployed to. Download and edit the sample file.


### Platform notes

Certain distributions demand certain tweaks to the variables for the driver and dynamic provisioner to operate correctly. See each platform for details.

#### Upstream Kubernetes

This is the default operating mode, no tweaks are needed.


#### Red Hat OpenShift and OKD
Applicable to Red Hat OpenShift 3.10 and 3.11. 4.x is not supported.

| Key        | Value                     | Description                                                                        |
|------------|---------------------------|------------------------------------------------------------------------------------|
| flavor     | openshift                 | nodeSelector tweaks to prevent provisioner to run on an infra node.                |
| podsMountDir | /var/lib/origin/openshift.local.volumes       | This is the directory where the kubelet bind mounts the volume for pods.            |


## Installing the Chart

To install the chart with the name `hpe-flexvolume`:

```

helm repo add hpe https://hpe-storage.github.io/co-deployments

helm install -f myvalues.yml --name hpe-flexvolume hpe/hpe-flexvolume-driver --namespace kube-system

```

**Note:** Omitting the `--name` flag will generate a human readable name.

## Check status of the Chart

To check status of the `hpe-flexvolume` deployment:

```

helm status hpe-flexvolume

```

## Uninstalling the Chart

To uninstall/delete the `hpe-flexvolume` deployment:

```

helm delete hpe-flexvolume --purge

```

## Alternative install method

In some cases it's more practical provide the local configuration via the `helm` command directly. Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```

helm install --name hpe-flexvolume hpe/hpe-flexvolume-driver \

--set backend=X.X.X.X --set username=admin --set password=xxxxxxxxx \

--set protocol=iscsi --set fsType=xfs --set mountConflictDelay=120

```

## Using the HPE FlexVolume Driver for Kubernetes

To enable dynamic provisioning of `PersistentVolume` through the use of `PersistentVolumeClaim` API objects, a `StorageClass` needs to be declared on the cluster. Please see the [HPE FlexVolume Driver for Kubernetes](https://github.com/hpe-storage/flexvolume-driver) repository for the official documentation for this Helm chart. Also, it's helpful to be familar with [persistent storage concepts](https://kubernetes.io/docs/concepts/storage/volumes/) in Kubernetes prior to deploying stateful workloads.

## Support

The HPE FlexVolume Driver for Kubernetes Helm chart is supported by the respective platform team. Currently supported platforms:

- HPE Nimble Storage

Please file issues through the regular support channels for the particular platform. Feature requests or general questions to developers may be filed through the [GitHub issue tracker](https://github.com/hpe-storage/co-deployments) for this project.

You may also join our Slack community to chat with HPE folks close to this project for inquiries not requring our immediate response. We hang out in `#NimbleStorage` and `#Kubernetes` at [slack.hpedev.io](https://slack.hpedev.io/).

# Contributing

We value all feedback and contributions. If you find any issues or want to contribute, please feel free to open an issue or file a PR. More details in [CONTRIBUTING.md](CONTRIBUTING.md)

# License

This is open source software licensed using the Apache License 2.0. Please see [LICENSE](LICENSE) for details.
