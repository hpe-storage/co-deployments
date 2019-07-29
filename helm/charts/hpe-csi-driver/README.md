# HPE CSI Volume Driver Helm Chart

## Introduction

The Container Storage Interface (CSI) Volume Driver for Kubernetes leverages HPE Nimble Storage to provide scalable and persistent storage for stateful applications.

## Features list

- Persistent Volumes
- Snapshots with Replication
- Online Volume Expansion
- Import Volumes

## Prerequisites

- Kubernetes version > 1.10 and < 1.14
- Kubernetes worker nodes must have the iSCSI and Multipath packages installed

## Installing the Chart

To install the chart with the name `hpe-csi`:

```console
helm repo add hpe https://github.rtplab.nimblestorage.com/dcs/helm/

helm install --name hpe-csi hpe/hpe-csi-driver --namespace kube-system
```

## Uninstalling the Chart

To uninstall/delete the `hpe-csi` deployment:

```console
helm delete hpe-csi --purge
```

## Testing the Chart

To test the chart with name `hpe-csi`:

```console
helm test hpe-csi --cleanup
```

## Configuration

The following table lists the configurable parameters of the HPE-CSI chart and their default values.

|  Parameter                |  Description                                                |  Default |
|---------------------------|-------------------------------------------------------------|----------|
| `arrayIp`                 | HPE Nimble Storage array IP                                 |`10.0.0.1`|
| `username`                | name used for the admin role                                |`admin`   |
| `password`                | password for the admin role                                 |`admin`   |
| `fsType`                  | type of file system you are using (ext4, ext3, xfs, btrfs)  |`xfs`     |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install --name hpe-csi hpe/hpe-csi-driver --set arrayIp=X.X.X.X --set username=admin --set password=xxxxxxxxx --set fsType=xfs
```
