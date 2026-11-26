These directories of resource definitions are generated with Helm. Do NOT edit manually.

Example:

```
export VERSION=0.0.0
helm template --version ${VERSION} --output-dir /tmp/workdir-${VERSION} --include-crds --no-hooks -n hpe-storage ../helm/charts/hpe-csi-driver
helm template --version ${VERSION} --include-crds --no-hooks -n hpe-storage ../helm/charts/hpe-csi-driver > csi-driver/latest.yaml
mkdir csi-driver/v${VERSION}
cp -a /tmp/workdir-${VERSION}/hpe-csi-driver/templates/ csi-driver/v${VERSION}
cp -a /tmp/workdir-${VERSION}/hpe-csi-driver/crds csi-driver/v${VERSION}/crds
```
