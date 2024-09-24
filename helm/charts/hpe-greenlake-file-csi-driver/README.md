# HPE GreenLake for File Storage CSI Driver Helm chart

The [HPE GreenLake for File Storage CSI Driver](https://scod.hpedev.io/filex_csi_driver/index.html) leverages HPE GreenLake for File Storage to provide scalable and persistent storage for stateful and ephemeral applications running on Kubernetes.

## Release highlights

The HPE GreenLake for File Storage CSI Driver Helm chart is the primary delivery vehicle for the HPE GreenLake for File Storage CSI Driver.

- All resources for HPE CSI drivers are available on [HPE Storage Container Orchestrator Documentation](https://scod.hpedev.io/) (SCOD).
- Visit [the latest release](https://scod.hpedev.io/filex_csi_driver/index.html#latest_release) on SCOD to learn what's new in this chart.

## Prerequisites

- Most recent Kubernetes distributions are supported
- Recent Ubuntu, SLES or RHEL (and its derives) compute nodes connected to their respective official package repositories
- Helm 3 (Version >= 3.2.0 required)

Refer to [Compatibility & Support](https://scod.hpedev.io/filex_csi_driver/index.html#compatibility_and_support) for currently supported versions of Kubernetes and compute node operating systems.

## Configuration and installation

The following table lists the configurable parameters of the chart and their default values.

| Parameter                 | Description                                                           | Default          |
|---------------------------|-----------------------------------------------------------------------|------------------|
| disableNodeConformance    | Disable automatic installation of NFS utilities on the compute nodes. | false            |
| kubeletRootDir            | The kubelet root directory path.                                      | /var/lib/kubelet |
| controller.labels         | Additional labels for the CSI driver controller Pod.                  | {}               |
| controller.nodeSelector   | Node labels for the CSI driver controller Pod assignment.             | {}               |
| controller.affinity       | Affinity rules for the CSI driver controller Pod.                     | {}               |
| controller.tolerations    | Node taints to tolerate for the CSI driver controller Pod.            | []               |
| controller.resources      | A resource block with requests and limits for controller containers.  | From values.yaml |
| node.labels               | Additional labels for CSI driver node Pods.                           | {}               |
| node.nodeSelector         | Node labels for the CSI driver node Pods assignment.                  | {}               |
| node.affinity             | Affinity rules for the CSI driver node Pods.                          | {}               |
| node.tolerations          | Node taints to tolerate for the CSI driver node Pods.                 | []               |
| node.resources            | A resource block with requests and limits for node containers.        | From values.yaml |
| images                    | Key/value pairs of CSI driver runtime images.                         | From values.yaml |
| imagePullPolicy           | Image pull policy (`Always`, `IfNotPresent`, `Never`).                | IfNotPresent     |

`*` = Disabling node conformance and configuration may prevent the CSI driver from functioning properly. See the [manual node configuration](https://scod.hpedev.io/csi_driver/operations.html#manual_node_configuration) section on SCOD to understand the consequences.

It's recommended to create a [values.yaml](https://github.com/hpe-storage/co-deployments/blob/master/helm/values/hpe-greenlake-file-csi-driver) file from the corresponding release of the chart and edit it to fit the environment the chart is being deployed to. Download and edit [a sample file](https://github.com/hpe-storage/co-deployments/blob/master/helm/values/hpe-greenlake-file-csi-driver).

**Note:** The chart is installed with all components and features enabled using reasonable defaults if no tweaks are needed.

### Installing the chart

To install the chart with the name `my-hpe-greenlake-file-csi-driver`:

Add HPE storage helm repo:

```
helm repo add hpe-storage https://hpe-storage.github.io/co-deployments/
helm repo update
```

Install the latest chart:

```
helm install --create-namespace -n hpe-storage my-hpe-greenlake-file-csi-driver hpe-storage/hpe-greenlake-file-csi-driver
```

**Note**: By default, the latest stable chart will be installed. If it's labeled with `prerelease` and a "beta" version tag, add `--version X.Y.Z-beta` to the command line to install a "beta" chart.

### Upgrading the chart

Refresh the Helm repository cache and upgrade.

```
helm repo update
helm upgrade -n hpe-storage my-hpe-greenlake-file-csi-driver hpe-storage/hpe-greenlake-file-csi-driver
```

#### Uninstalling the chart

To uninstall the `hpe-greenlake-file-csi-driver` chart:

```
helm uninstall hpe-greenlake-file-csi-driver -n hpe-storage
```

## Using persistent storage with Kubernetes

Enable dynamic provisioning of persistent storage by creating a `StorageClass` API object that references a `Secret` which maps to a storage backend. Refer to the [HPE GreenLake for File Storage CSI Driver](https://scod.hpedev.io/filex_csi_driver/deployment.html#add_a_storage_backend) documentation on SCOD. Also, it's helpful to be familiar with [persistent storage concepts](https://kubernetes.io/docs/concepts/storage/volumes/) in Kubernetes prior to deploying stateful workloads.

## Support

The HPE GreenLake for File Storage CSI Driver Helm chart is fully supported by HPE.

Formal support statements for each HPE backend is [available on SCOD](https://scod.hpedev.io/legal/support). Use this facility for formal support of your HPE storage products, including the Helm chart.

## Community

Please file any issues, questions or feature requests you may have [here](https://github.com/hpe-storage/co-deployments/issues) (do not use this facility for support inquiries of your HPE storage product, see [SCOD](https://scod.hpedev.io/legal/support) for support). You may also join our Slack community to chat with HPE folks close to this project. We hang out in `#Alletra`, `#HPE-GreenLake-Data-Services`, and `#Kubernetes`. Sign up at [developer.hpe.com/slack-signup](https://developer.hpe.com/slack-signup) and login at [hpedev.slack.com](https://hpedev.slack.com/)

## Contributing

We value all feedback and contributions. If you find any issues or want to contribute, please feel free to open an issue or file a PR. More details in [CONTRIBUTING.md](https://github.com/hpe-storage/co-deployments/blob/master/CONTRIBUTING.md)

## License

This is open source software licensed using the Apache License 2.0. Please see [LICENSE](https://github.com/hpe-storage/co-deployments/blob/master/LICENSE) for details.
