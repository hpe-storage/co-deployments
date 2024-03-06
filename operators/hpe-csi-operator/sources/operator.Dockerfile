# Build the manager binary
%FROM%
LABEL name="csi-driver-operator" \
      maintainer="HPE Storage Containers Team" \
      vendor="HPE" \
      version="%SEMVER%" \
      release="%SEMVER%" \
      summary="HPE CSI Operator" \
      description="HPE CSI Operator for Kubernetes" \
      io.k8s.display-name="HPE CSI Operator for Kubernetes" \
      io.k8s.description="The HPE CSI Operator for Kubernetes enables container orchestrators, such as Kubernetes and OpenShift, to manage the life-cycle of persistent storage." \
      io.openshift.tags=hpe,csi,hpe-csi-driver
ENV HOME=/opt/helm
COPY watches.yaml ${HOME}/watches.yaml
COPY helm-charts  ${HOME}/helm-charts
COPY LICENSE /licenses/
WORKDIR ${HOME}
