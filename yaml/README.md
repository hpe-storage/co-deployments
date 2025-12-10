These directories of resource definitions are generated with Helm. Do NOT edit manually.

Example:

```
export VERSION=v0.0.0
helm template --output-dir /tmp/workdir-${VERSION} --include-crds --no-hooks -n hpe-storage ../helm/charts/hpe-csi-driver
mkdir csi-driver/${VERSION}
cp -a /tmp/workdir-${VERSION}/hpe-csi-driver/templates/ csi-driver/${VERSION}
cp -a /tmp/workdir-${VERSION}/hpe-csi-driver/crds csi-driver/${VERSION}/crds
```
