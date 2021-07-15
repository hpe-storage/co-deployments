# HPE Storage Array Exporter for Prometheus Helm chart

The [HPE Storage Array Exporter for Prometheus](https://hpe-storage.github.io/array-exporter) provides storage system information in the form of [Prometheus](https://prometheus.io/) metrics.  It can be used in combination with [HPE CSI Info Metrics Provider for Prometheus](https://scod.hpedev.io/) metrics to focus on storage resources used within a Kubernetes cluster.

## Prerequisites

- Upstream Kubernetes version >= 1.18
- Most Kubernetes distributions are supported
- Helm 3 (version >= 3.2.0)

## Configuration and installation

The chart has these configurable parameters and default values.

| Parameter | Description | Default |
|---------------------------|------------------------------------------------------------------------|------------------|
| acceptEula | Confirm your acceptance of the HPE End User License Agreement at https://www.hpe.com/us/en/software/licensing.html by setting this value to true. | false |
| arraySecret | The name of a Secret in the same namespace as the Helm chart installation providing storage array access information: `address` (or `backend`), `username`, and `password`. | *none* |
| registry | The repository from which to pull container images. | quay.io |
| imagePullPolicy | Container image pull policy (`Always`, `IfNotPresent`, `Never`). | IfNotPresent |
| logLevel | Minimum severity of messages to output (`info`, `debug`, `trace`, `warn`, `error`). | info |
| metrics.disableIntrospection | Exclude metrics about the metrics provider itself, with prefixes such as `promhttp`, `process`, and `go`. | false |
| service.type | The type of Service to create, ClusterIP for access solely from within the cluster or NodePort to provide access from outside the cluster (`ClusterIP`, `NodePort`). | ClusterIP |
| service.port | The TCP port at which to expose access to storage array metrics within the cluster. | 9090 |
| service.nodePort | The TCP port at which to expose access to storage array metrics externally at each cluster node, if the Service type is NodePort and automatic assignment is not desired. | *none* |
| service.customLabels | Labels to add to the Service, for example to include target labels in a ServiceMonitor scrape configuration. | {} |

Use of a values.yaml file is recommended.  Download and edit [a sample values.yaml file](https://github.com/hpe-storage/co-deployments/blob/master/helm/values/array-exporter) corresponding to the chart version and edit the settings according to the deployment environment.

The `arraySecret` parameter is required and has no default value.  A Secret used by the [HPE CSI Driver for Kubernetes](https://scod.hpedev.io/csi_driver/index.html) can be reused without modification.  Otherwise, use [this example](https://github.com/hpe-storage/co-deployments/blob/master/yaml/array-exporter/edge/hpe-array-exporter-secret.yaml) to create a new one.

**Important**: The `acceptEula` value must be set to `true` manually, confirming your acceptance of the [HPE End User License Agreement](https://www.hpe.com/us/en/software/licensing.html).

### Installing the chart

To install the chart with the name `my-hpe-array-exporter`:

Add HPE Helm repo:

```
helm repo add hpe-storage https://hpe-storage.github.io/co-deployments/
helm repo update
```

Install the latest chart:

```
kubectl create ns hpe-storage
helm install my-hpe-array-exporter hpe-storage/hpe-array-exporter -n hpe-storage -f myvalues.yaml
```

Alternatively, specify each parameter using the `--set key=value[,key=value]` option in lieu of a values.yaml file:

```
helm install my-hpe-array-exporter hpe-storage/hpe-array-exporter -n hpe-storage \
  --set acceptEula=xxxx
```

**Note**: If the latest version of the chart is labeled with `prerelease` and a "beta" tag, add `--version X.Y.Z` to install a "stable" chart.

### Uninstalling the chart

To uninstall the `my-hpe-array-exporter` chart:

```
helm uninstall my-hpe-array-exporter -n hpe-storage
```

## Support

The HPE Storage Array Exporter for Prometheus Helm chart is fully supported by HPE. A formal support facility for HPE storage products can be found at [SCOD](https://scod.hpedev.io/legal/support).

## Community

Please file any issues, questions or feature requests you may have [here](https://github.com/hpe-storage/co-deployments/issues). However, see [SCOD](https://scod.hpedev.io/legal/support) for support inquiries related to your HPE storage product. You may also join our Slack community to chat with HPE folks close to this project. We hang out in `#NimbleStorage`, `#3par-primera`, and `#Kubernetes`. Sign up at [slack.hpedev.io](https://slack.hpedev.io/) and login at [hpedev.slack.com](https://hpedev.slack.com/)

## Contributing

We value all feedback and contributions. If you find any issues or want to contribute, please feel free to open an issue or file a PR. More details in [CONTRIBUTING.md](https://github.com/hpe-storage/co-deployments/blob/master/CONTRIBUTING.md)

## License

This is open source software licensed using the Apache License 2.0. Please see [LICENSE](https://github.com/hpe-storage/co-deployments/blob/master/LICENSE) for details.
