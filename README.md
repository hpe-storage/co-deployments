# Container orchestrator (CO) deployment declarations
This repository contains the source declarations to deploy CO drivers (CSI and FlexVolume) for HPE storage platforms.

## Using Helm
[Helm](https://helm.sh) is the recommended way to deploy both the FlexVolume and CSI driver for HPE storage products.

- Deploy the [HPE FlexVolume Driver for Kubernetes](helm/charts/hpe-flexvolume-driver)
- Deploy the [HPE CSI Driver for Kubernetes](helm/charts/hpe-csi-driver)

**Note:** Helm 3.x is currently not supported.

## Using Helm Operator
Deploy both the FlexVolume and CSI driver for HPE storage products using Helm Operators

- Deploy the [HPE FlexVolume Driver for Kubernetes](operators/hpe-flexvolume-operator)
- Deploy the [HPE CSI Driver for Kubernetes](operators/hpe-csi-operator)

## DIY with your CO of choice
We provide the [raw YAML files](yaml) to deploy the [HPE CSI Driver](https://github.com/hpe-storage/csi-driver) with the respective [Container Storage Provider](https://github.com/hpe-storage/container-storage-provider) (CSP). These files are usually referenced elsewhere on how to get a particular setup up and running. We recommend using the [Helm charts](helm/charts) first and foremost.

- YAML files for the [HPE FlexVolume Driver for Kubernetes](yaml/flexvolume-driver)
- YAML files for the [HPE CSI Driver for Kubernetes](yaml/csi-driver)

## Support
Please see the respective CO driver declaration for support options. Please file any issues, questions or feature requests [here](https://github.com/hpe-storage/co-deployments/issues). You may also join our Slack community to chat with HPE folks close to this project. We hang out in `#NimbleStorage` and `#Kubernetes` at [slack.hpedev.io](https://slack.hpedev.io/).

## Contributing
We value all feedback and contributions. If you find any issues or want to contribute, please feel free to open an issue or file a PR. More details in [CONTRIBUTING.md](CONTRIBUTING.md)

## License
This is open source software licensed using the Apache License 2.0. Please see [LICENSE](LICENSE) for details.
