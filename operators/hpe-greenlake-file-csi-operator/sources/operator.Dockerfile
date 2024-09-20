# Build the manager binary
%FROM%
LABEL name="filex-csi-driver-operator" \
      maintainer="HPE Storage Containers Team" \
      vendor="HPE" \
      version="%SEMVER%" \
      release="%SEMVER%" \
      summary="HPE GreenLake for File Storage CSI Operator" \
      description="HPE GreenLake for File Storage CSI Operator" \
      io.k8s.display-name="HPE GreenLake for File Storage CSI Operator" \
      io.k8s.description="The HPE GreenLake for File Storage CSI Operatorenables container orchestrators, such as Kubernetes and OpenShift, to manage the life-cycle of persistent storage." \
      io.openshift.tags=hpe,csi,hpe-greenlake-file-csi-driver
ENV HOME=/opt/helm
COPY watches.yaml ${HOME}/watches.yaml
COPY helm-charts  ${HOME}/helm-charts
COPY LICENSE /licenses/
WORKDIR ${HOME}
