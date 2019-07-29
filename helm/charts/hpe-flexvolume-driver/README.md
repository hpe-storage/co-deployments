# HPE FlexVolume Driver Helm Chart

## Introduction

FlexVolume Driver for Kubernetes leverages HPE Nimble Storage to provide scalable and persistent storage for stateful applications.

## Features list

- Persistent Volumes
- Snapshots with Replication
- Import Volumes

## Prerequisites

- Kubernetes version > 1.10
- Kubernetes worker nodes must have the iSCSI and Multipath packages installed

## Installing the Chart

To install the chart with the name `hpe-flexvolume`:

```console
helm repo add hpe https://github.rtplab.nimblestorage.com/dcs/helm/

helm install --name hpe-flexvolume hpe/hpe-flexvolume-driver` --namespace kube-system
```

## Uninstalling the Chart

To uninstall/delete the `hpe-flexvolume` deployment:

```console
helm delete hpe-flexvolume --purge
```

## Testing the Chart

To test the chart with name `hpe-flexvolume`:

```console
helm test hpe-flexvolume --cleanup
```

## Configuration

The following table lists the configurable parameters of the HPE FlexVolume Driver chart and their default values.

|  Parameter                |  Description                                                |  Default |
|---------------------------|-------------------------------------------------------------|----------|
| `arrayIp`                 | HPE Nimble Storage array IP                                 |`10.0.0.1`|
| `username`                | name used for the admin role                                |`admin`   |
| `password`                | password for the admin role                                 |`admin`   |
| `protocol`                | protocol to use for this array (fc or iscsi)                |`iscsi`   |
| `fsType`                  | type of file system you are using (ext4, ext3, xfs, btrfs)  |`xfs`     |
| `mountConflictDelay`      | wait seconds before taking over volume from another node    |`150`     |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install --name hpe-flexvolume hpe/hpe-flexvolume-driver --set arrayIp=X.X.X.X --set username=admin --set password=xxxxxxxxx --set protocol=iscsi --set fsType=xfs --set mountConflictDelay=120
```
