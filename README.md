# Container orchestrator (CO) deployment declarations

This repository contains the source declarations to deploy CO drivers (CSI and FlexVolume) for HPE storage platforms.

## Using Helm

[Helm](https://helm.sh) is the recommended way to deploy both the CSI and FlexVolume driver for HPE storage products.

- Deploy the [HPE CSI Driver for Kubernetes](helm/charts/hpe-csi-driver)
- Deploy the [HPE FlexVolume Driver for Kubernetes](helm/charts/hpe-flexvolume-driver)

The Helm chart is also rendered on [ArtifactHub.io](https://artifacthub.io/packages/helm/hpe-storage/hpe-csi-driver).

## Using Helm Operator

Deploy both the CSI driver and FlexVolume for HPE storage products using Helm Operators

- Deploy the [HPE CSI Driver for Kubernetes](operators/hpe-csi-operator)
- Deploy the [HPE FlexVolume Driver for Kubernetes](operators/hpe-flexvolume-operator)

The Operator is also available on [OperatorHub.io](https://operatorhub.io/operator/hpe-csi-operator).

## DIY with your CO of choice

We provide the [raw YAML files](yaml) to deploy the [HPE CSI Driver](https://github.com/hpe-storage/csi-driver) with the respective [Container Storage Provider](https://github.com/hpe-storage/container-storage-provider) (CSP). These files are usually referenced elsewhere on how to get a particular setup up and running. We recommend using the [Helm charts](helm/charts) first and foremost.

- YAML files for the [HPE CSI Driver for Kubernetes](yaml/csi-driver)
- YAML files for the [HPE FlexVolume Driver for Kubernetes](yaml/flexvolume-driver)

How to perform an [advanced manual install](https://scod.hpedev.io/csi_driver/deployment.html#advanced_install) of the CSI driver.

## Documentation

For information on how to use the actual CSI driver and related technologies, visit [HPE Storage Container Orchestrator Documentation](https://scod.hpedev.io) (SCOD).

## Support

The CO deployment manifests are fully supported by HPE and is Generally Available.

Formal support statements for each HPE supported product is [available on SCOD](https://scod.hpedev.io/legal/support). Use this facility for formal support of your HPE storage products, including the CSI and FlexVolume drivers.

## Community

Please file any issues, questions or feature requests you may have [here](https://github.com/hpe-storage/co-deployments/issues) (do not use this facility for support inquiries of your HPE storage product, see [SCOD](https://scod.hpedev.io/legal/support) for support). You may also join our Slack community to chat with HPE folks close to this project. We hang out in `#NimbleStorage`, `#3par-primera`, `#hpe-cloud-volumes` and `#Kubernetes`. Sign up at [slack.hpedev.io](https://slack.hpedev.io/) and login at [hpedev.slack.com](https://hpedev.slack.com/)

## Contributing

We value all feedback and contributions. If you find any issues or want to contribute, please feel free to open an issue or file a PR. More details in [CONTRIBUTING.md](CONTRIBUTING.md)

## License

This is open source software licensed using the Apache License 2.0. Please see [LICENSE](LICENSE) for details.
