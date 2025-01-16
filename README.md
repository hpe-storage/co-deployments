# Container orchestrator (CO) deployment declarations

This repository contains the source declarations to deploy CO drivers (CSI and FlexVolume) and metrics providers (Array Exporter and CSI Info Metrics Provider) for HPE storage platforms.

## Using Helm

[Helm](https://helm.sh) is the recommended way to deploy these container orchestrator facilities.

- Deploy the [HPE CSI Driver for Kubernetes](helm/charts/hpe-csi-driver)
- Deploy the [HPE GreenLake for File Storage CSI Driver](helm/charts/hpe-greenlake-file-csi-driver)
- Deploy the [HPE Storage Array Exporter for Prometheus](helm/charts/hpe-array-exporter)
- Deploy the [HPE CSI Info Metrics Provider for Prometheus](helm/charts/hpe-csi-info-metrics)

The HPE CSI Driver for Kubernetes Helm chart is also rendered on [ArtifactHub.io](https://artifacthub.io/packages/helm/hpe-storage/hpe-csi-driver).

## Using Helm Operator

Deploy both the CSI driver and FlexVolume for HPE storage products using Helm Operators

- Deploy the [HPE CSI Operator for Kubernetes](operators/hpe-csi-operator)

The HPE CSI Operator for Kubernetes is also available on [OperatorHub.io](https://operatorhub.io/operator/hpe-csi-operator).

## DIY with your CO of choice

We provide the [raw YAML files](yaml) to deploy the [HPE CSI Driver](https://github.com/hpe-storage/csi-driver) with the respective [Container Storage Provider](https://github.com/hpe-storage/container-storage-provider) (CSP). These files are usually referenced elsewhere on how to get a particular setup up and running. We recommend using the [Helm charts](helm/charts) first and foremost.

- YAML files for the [HPE CSI Driver for Kubernetes](yaml/csi-driver)
- YAML files for the [HPE Storage Array Exporter for Prometheus](yaml/array-exporter)
- YAML files for the [HPE CSI Info Metrics Provider for Prometheus](yaml/csi-info-metrics)

How to perform an [advanced manual install](https://scod.hpedev.io/csi_driver/deployment.html#advanced_install) of the CSI driver.

## Documentation

For information on how to use the actual CSI driver and related technologies, including the HPE CSI Info Metrics Provider for Prometheus, visit [HPE Storage Container Orchestrator Documentation](https://scod.hpedev.io) (SCOD).

Also see the linked documentation for the [HPE Storage Array Exporter for Prometheus](https://hpe-storage.github.io/array-exporter).

## Support

The CO deployment manifests are fully supported by HPE and are Generally Available.

Formal support statements for each HPE supported product are [available on SCOD](https://scod.hpedev.io/legal/support). Use this facility for formal support of your HPE storage products, including the CSI and FlexVolume drivers and the metrics providers.

## Community

Please file any issues, questions or feature requests you may have [here](https://github.com/hpe-storage/co-deployments/issues). However, see [SCOD](https://scod.hpedev.io/legal/support) for support inquiries related to your HPE storage product. You may also join our Slack community to chat with HPE folks close to this project. We hang out in `#alletra`, and `#Kubernetes`. Sign up at [developer.hpe.com](https://developer.hpe.com/slack-signup/) and login at [hpedev.slack.com](https://hpedev.slack.com/)

## Contributing

We value all feedback and contributions. If you find any issues or want to contribute, please feel free to open an issue or file a PR. More details in [CONTRIBUTING.md](CONTRIBUTING.md)

## License

This is open source software licensed using the Apache License 2.0. Please see [LICENSE](LICENSE) for details.
